library stage;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'dart:js';

part 'stage_element.dart';

/*
 * TODO:
 * implement stage resize
 * Implement delete
 * Implement anchor guidelines for Gap, Width, Height
 * Implement element rotation
 */

class AnchorStream {
  StreamSubscription _mouseMove, _mouseUp, _mouseOver, _keyDown;

  String _cursor;
  String get cursor => _cursor;

  dynamic _initRect;
  dynamic get initRect => _initRect;
  Point _startPoint;
  Point get startPoint => _startPoint;

  AnchorStream(this._cursor) {
    if (_cursor == null) {
      _cursor = "default";
    }
  }

  bool _activated = false;
  bool get activated => _activated;

  bool activate(dynamic arg_initRect, Point arg_startPoint, StreamSubscription arg_mouseMove, StreamSubscription arg_mouseUp, StreamSubscription arg_mouseOver, StreamSubscription arg_keyDown) {
    bool ret = false;

    //print("activation called");

    deactivate();

    if (arg_initRect != null && arg_startPoint != null) {
      ret = true;
      _initRect = arg_initRect;
      _startPoint = arg_startPoint;

      _activated = true;

      _mouseMove = arg_mouseMove;
      _mouseUp = arg_mouseUp;
      _mouseOver = arg_mouseOver;
      _keyDown = arg_keyDown;

      //print("activating");
    }

    return ret;
  }

  void deactivate() {
    //print("deactivating");

    _initRect = null;
    _startPoint = null;

    _activated = false;

    if (_mouseMove != null) {
      _mouseMove.cancel();
      _mouseMove = null;
    }

    if (_mouseUp != null) {
      _mouseUp.cancel();
      _mouseUp = null;
    }

    if (_mouseOver != null) {
      _mouseOver.cancel();
      _mouseOver = null;
    }

    if (_keyDown != null) {
      _keyDown.cancel();
      _keyDown = null;
    }
  }
}

/**
 * dock-stage is a stage used to create GUI interfaces like XCode Storyboard.
 *
 *     <dock-stage width="720" height="480"></dock-stage>
 *
 * @class dock-stage
 */
@CustomTag('dock-stage')
class DockStage extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  DockStage.created() : super.created() {
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  DivElement _anchornw;
  DivElement _anchorne;
  DivElement _anchorsw;
  DivElement _anchorse;
  DivElement _anchorn;
  DivElement _anchore;
  DivElement _anchorw;
  DivElement _anchors;

  DivElement _verAutoGL;
  DivElement _horAutoGL;

  DivElement _groupSel;

  @override
  void ready() {
    super.ready();

    _canvas = shadowRoot.querySelector("#canvas");
    _parcanvas = shadowRoot.querySelector("#canvas-parent");

    _anchornw = shadowRoot.querySelector(".anchor-nw");
    _anchorne = shadowRoot.querySelector(".anchor-ne");
    _anchorsw = shadowRoot.querySelector(".anchor-sw");
    _anchorse = shadowRoot.querySelector(".anchor-se");
    _anchorn = shadowRoot.querySelector(".anchor-n");
    _anchors = shadowRoot.querySelector(".anchor-s");
    _anchore = shadowRoot.querySelector(".anchor-e");
    _anchorw = shadowRoot.querySelector(".anchor-w");

    _verAutoGL = shadowRoot.querySelector("#ver-auto-gline");
    _horAutoGL = shadowRoot.querySelector("#hor-auto-gline");

    _groupSel = shadowRoot.querySelector("#group-selector");

    _clicksub = onMouseDown.listen(_stageClicked);

    onMouseWheel.listen((WheelEvent event) {
      if (event.ctrlKey && event.shiftKey) {
        if (event.deltaX > 0) {
          zoomOut();
        } else {
          zoomIn();
        }
        scrollToCenter();
      }
    });

    stagebgcolorChanged();

    /*onMouseDown.listen((MouseEvent ke) {
      getScreenShot();
    });*/

    _setupResizeHandler();
  }

  Future getScreenShot() {
    JsFunction dartcall = context["dartcall"];

    context["boom"] = callb1;
    dartcall.apply([_canvas, "boom"]);
  }

  callb1(CanvasElement canvas) {
    document.body.append(canvas);
  }

  @override
  void attached() {
    super.attached();
    //scrollToCenter();
  }

  @override
  void detached() {
    super.detached();
  }

  StreamSubscription _clicksub;
  StreamSubscription _mouseout, _mousemove, _mouseup;
  StreamSubscription _moveEscape;

  AnchorStream _selStream;

  /* Element selection */
  void _stageClicked(MouseEvent event) {
    HtmlElement realTarget;
    for (StageElement _elem in _elements.reversed) {
      if (_elem.getBoundingClientRect().containsPoint(event.client)) {
        realTarget = _elem;
        break;
      }
    }

    bool multi = event.shiftKey;
    if (_elements.contains(realTarget)) {
      StageElement target = realTarget;
      if (multi) {
        if (target.isSelected) {
          deselectElement(target);
        } else {
          if (target.selectable) {
            selectElement(target);
          }
        }
      } else {
        if (!_selected.contains(target)) {
          deselectAllElements();
        }

        selectElement(target);
      }
      if (_selected.length != 0) {
        _startMove(event);
      }
    } else {
      deselectAllElements();
      if (event.button == 0) {
        _groupSel.style.left = "${0}px";
        _groupSel.style.top = "${0}px";
        _groupSel.style.width = "0px";
        _groupSel.style.height = "0px";

        _groupSel.classes.add("show");

        StreamSubscription selMMove = onMouseMove.listen((MouseEvent event) {
          Point selStartPt = _selStream.initRect - _canvas.offset.topLeft;
          Point selEndPt = event.offset + new Point(scrollLeft, scrollTop) - _canvas.offset.topLeft;

          Rectangle selRectangle = new Rectangle.fromPoints(selStartPt, selEndPt);
          style.cursor = "crosshair";
          _groupSel.style.left = "${selRectangle.left}px";
          _groupSel.style.top = "${selRectangle.top}px";
          _groupSel.style.width = "${selRectangle.width}px";
          _groupSel.style.height = "${selRectangle.height}px";
        });
        StreamSubscription selMUp = onMouseUp.listen((MouseEvent mpe) {
          Point selEndPt = mpe.client;
          Rectangle selRectangle = new Rectangle.fromPoints(_selStream.startPoint, selEndPt);
          deselectAllElements();
          for (StageElement _elem in _elements) {
            if (_elem.getBoundingClientRect().intersects(selRectangle)) {
              selectElement(_elem);
            }
          }
          _cancelSelRegion();
        });
        StreamSubscription selMOut = onMouseOut.listen((MouseEvent mpe) => _cancelSelRegion());
        StreamSubscription selKDown = onKeyDown.listen((KeyboardEvent kbe) {
          if (kbe.keyCode == KeyCode.ESC) {
            _cancelSelRegion();
          }
        });

        Point startPoint = event.offset + new Point(scrollLeft, scrollTop);

        _selStream.activate(startPoint, event.client, selMMove, selMUp, selMOut, selKDown);
      }
    }
  }

  void _cancelSelRegion() {
    _groupSel.classes.remove("show");
    _selStream.deactivate();
    style.cursor = "default";
  }

  void selectElement(StageElement _elem) {
    if (_elem.selectable && !_elem.isSelected) {
      _selected.add(_elem);
      _elem._selected();
      fireElementSelectedEvent(_elem);
    }
    _showAnchors();
  }

  void deselectElement(StageElement _elem) {
    if (_elem.isSelected) {
      _selected.remove(_elem);
      _elem._deselected();
      fireElementDeselectedEvent(_elem);
      if (_selected.length == 0) {
        fireAllElementsDeselectedEvent();
      }
    }
    _showAnchors();
  }

  void deselectAllElements() {
    _selected.forEach((StageElement _elem) {
      _elem._deselected();
      fireElementDeselectedEvent(_elem);
    });
    _selected.clear();
    fireAllElementsDeselectedEvent();
    _hideAnchors();
  }

  /* Move */
  Point _moveStartPt;
  bool _wasMoving = false;

  int _detectHorMiddleGL(Rectangle rect) {
    int ret;

    int lmiddle = rect.left + (rect.width ~/ 2);
    if (lmiddle == scaledWidth ~/ 2) {
      ret = lmiddle;
    }
    for (StageElement _elem in _elements) {
      if (!_selected.contains(_elem)) {
        int elmid = _elem.offset.left + (_elem.offsetWidth ~/ 2);
        if (lmiddle == elmid) {
          ret = lmiddle;
        }
      }
    }

    return ret;
  }

  int _detectLeftGL(Rectangle rect) {
    int ret;

    if (rect.left == 0) {
      ret = rect.left;
    } else if (rect.left == scaledWidth) {
      ret = rect.left;
    }
    for (StageElement _elem in _elements) {
      if (!_selected.contains(_elem)) {
        if (rect.left == _elem.offsetLeft) {
          ret = rect.left;
        } else if (rect.left == _elem.offset.right) {
          ret = rect.left;
        }
      }
    }

    return ret;
  }

  int _detectRightGL(Rectangle rect) {
    int ret;

    if (rect.right == 0) {
      ret = rect.right;
    } else if (rect.right == scaledWidth) {
      ret = rect.right;
    }
    for (StageElement _elem in _elements) {
      if (!_selected.contains(_elem)) {
        if (rect.right == _elem.offset.right) {
          ret = rect.right;
        } else if (rect.right == _elem.offset.left) {
          ret = rect.right;
        }
      }
    }

    return ret;
  }

  int _detectVerMiddleGL(Rectangle rect) {
    int ret;

    int tmiddle = rect.top + (rect.height ~/ 2);
    if (tmiddle == scaledHeight ~/ 2) {
      ret = tmiddle;
    }
    for (StageElement _elem in _elements) {
      if (!_selected.contains(_elem)) {
        int elmid = _elem.offset.top + (_elem.offsetHeight ~/ 2);
        if (tmiddle == elmid) {
          ret = tmiddle;
        }
      }
    }

    return ret;
  }

  int _detectTopGL(Rectangle rect) {
    int ret;

    if (rect.top == 0) {
      ret = rect.top;
    } else if (rect.top == scaledHeight) {
      ret = rect.top;
    }
    for (StageElement _elem in _elements) {
      if (!_selected.contains(_elem)) {
        if (rect.top == _elem.offsetTop) {
          ret = rect.top;
        } else if (rect.top == _elem.offset.bottom) {
          ret = rect.top;
        }
      }
    }

    return ret;
  }

  int _detectBottomGL(Rectangle rect) {
    int ret;

    if (rect.bottom == 0) {
      ret = rect.bottom;
    } else if (rect.bottom == scaledHeight) {
      ret = rect.bottom;
    }
    for (StageElement _elem in _elements) {
      if (!_selected.contains(_elem)) {
        if (rect.bottom == _elem.offset.bottom) {
          ret = rect.bottom;
        } else if (rect.bottom == _elem.offset.top) {
          ret = rect.bottom;
        }
      }
    }

    return ret;
  }


  Point _detectMoveAutoGuidelines(Rectangle rect) {
    int vertAnchor;
    int horAnchor;
    //TODO: also find equal gaps

    vertAnchor = _detectHorMiddleGL(rect);

    if (vertAnchor == null) {
      vertAnchor = _detectLeftGL(rect);
    }

    if (vertAnchor == null) {
      vertAnchor = _detectRightGL(rect);
    }

    horAnchor = _detectVerMiddleGL(rect);

    if (horAnchor == null) {
      horAnchor = _detectTopGL(rect);
    }

    if (horAnchor == null) {
      horAnchor = _detectBottomGL(rect);
    }

    if (vertAnchor != null) {
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${vertAnchor}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    if (horAnchor != null) {
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${horAnchor}px";
    } else {
      _horAutoGL.classes.remove("show");
    }

    return new Point(vertAnchor, horAnchor);
  }

  void hideAutoGuidelines() {
    _verAutoGL.classes.remove("show");
    _horAutoGL.classes.remove("show");
  }

  Point _detectResizeNWAutoGuidelines(Rectangle rect) {
    int verAnchor;
    int horAnchor;
    //TODO: also find equal gaps

    verAnchor = _detectHorMiddleGL(rect);

    if (verAnchor == null) {
      verAnchor = _detectLeftGL(rect);
    }

    horAnchor = _detectVerMiddleGL(rect);

    if (horAnchor == null) {
      horAnchor = _detectTopGL(rect);
    }

    if (verAnchor != null) {
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${verAnchor}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    if (horAnchor != null) {
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${horAnchor}px";
    } else {
      _horAutoGL.classes.remove("show");
    }

    return new Point(verAnchor, horAnchor);
  }

  Point _detectResizeNEAutoGuidelines(Rectangle rect) {
    int verAnchor;
    int horAnchor;
    //TODO: also find equal gaps

    verAnchor = _detectHorMiddleGL(rect);

    if (verAnchor == null) {
      verAnchor = _detectRightGL(rect);
    }

    horAnchor = _detectVerMiddleGL(rect);

    if (horAnchor == null) {
      horAnchor = _detectTopGL(rect);
    }

    if (verAnchor != null) {
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${verAnchor}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    if (horAnchor != null) {
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${horAnchor}px";
    } else {
      _horAutoGL.classes.remove("show");
    }

    return new Point(verAnchor, horAnchor);
  }

  Point _detectResizeSEAutoGuidelines(Rectangle rect) {
    int verAnchor;
    int horAnchor;
    //TODO: also find equal gaps

    verAnchor = _detectHorMiddleGL(rect);

    if (verAnchor == null) {
      verAnchor = _detectRightGL(rect);
    }

    horAnchor = _detectVerMiddleGL(rect);

    if (horAnchor == null) {
      horAnchor = _detectBottomGL(rect);
    }

    if (verAnchor != null) {
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${verAnchor}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    if (horAnchor != null) {
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${horAnchor}px";
    } else {
      _horAutoGL.classes.remove("show");
    }

    return new Point(verAnchor, horAnchor);
  }

  Point _detectResizeSWAutoGuidelines(Rectangle rect) {
    int verAnchor;
    int horAnchor;
    //TODO: also find equal gaps

    verAnchor = _detectHorMiddleGL(rect);

    if (verAnchor == null) {
      verAnchor = _detectLeftGL(rect);
    }

    horAnchor = _detectVerMiddleGL(rect);

    if (horAnchor == null) {
      horAnchor = _detectBottomGL(rect);
    }

    if (verAnchor != null) {
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${verAnchor}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    if (horAnchor != null) {
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${horAnchor}px";
    } else {
      _horAutoGL.classes.remove("show");
    }

    return new Point(verAnchor, horAnchor);
  }

  int _detectResizeNAutoGuidelines(Rectangle rect) {
    int horAnchor;
    //TODO: also find equal gaps

    horAnchor = _detectVerMiddleGL(rect);

    if (horAnchor == null) {
      horAnchor = _detectTopGL(rect);
    }

    _verAutoGL.classes.remove("show");

    if (horAnchor != null) {
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${horAnchor}px";
    } else {
      _horAutoGL.classes.remove("show");
    }

    return horAnchor;
  }

  int _detectResizeSAutoGuidelines(Rectangle rect) {
    int horAnchor;
    //TODO: also find equal gaps

    horAnchor = _detectVerMiddleGL(rect);

    if (horAnchor == null) {
      horAnchor = _detectBottomGL(rect);
    }

    _verAutoGL.classes.remove("show");

    if (horAnchor != null) {
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${horAnchor}px";
    } else {
      _horAutoGL.classes.remove("show");
    }

    return horAnchor;
  }

  int _detectResizeEAutoGuidelines(Rectangle rect) {
    int verAnchor;
    //TODO: also find equal gaps

    verAnchor = _detectHorMiddleGL(rect);

    if (verAnchor == null) {
      verAnchor = _detectRightGL(rect);
    }

    if (verAnchor != null) {
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${verAnchor}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    _horAutoGL.classes.remove("show");

    return verAnchor;
  }

  int _detectResizeWAutoGuidelines(Rectangle rect) {
    int verAnchor;
    //TODO: also find equal gaps

    verAnchor = _detectHorMiddleGL(rect);

    if (verAnchor == null) {
      verAnchor = _detectLeftGL(rect);
    }

    if (verAnchor != null) {
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${verAnchor}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    _horAutoGL.classes.remove("show");

    return verAnchor;
  }

  /*
   * Called by the [StageElement] when the user starts to move
   */
  void _startMove(MouseEvent event) {
    if (event.button == 0) {
      _mousemove = onMouseMove.listen(_processMove);
      _mouseup = onMouseUp.listen(_stopMove);
      _mouseout = onMouseLeave.listen(_stopMove);
      _moveEscape = document.onKeyDown.listen((KeyboardEvent event) {
        if (event.keyCode == KeyCode.ESC) {
          _stopMove(null);
          for (StageElement _elem in _selected) {
            _elem.left = _elem._savedPosBeforeMove.x / stagescale;
            _elem.top = _elem._savedPosBeforeMove.y / stagescale;
          }
        }
      });
      _moveStartPt = event.page;

      for (StageElement _elem in _selected) {
        _elem._savedPosBeforeMove = new Point(_elem.offsetLeft, _elem.offsetTop);
      }
    }
  }

  void _processMove(MouseEvent event) {

    Rectangle rect;

    style.cursor = "move";

    if (getBoundingClientRect().containsPoint(event.page)) {
      Point diff = event.page - _moveStartPt;
      for (StageElement _elem in _selected) {
        int left = (_elem._savedPosBeforeMove.x + diff.x) / stagescale;
        int top = (_elem._savedPosBeforeMove.y + diff.y) / stagescale;

        _elem.left = left;
        _elem.top = top;

        //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
        rect = new Rectangle(_elem.scaledleft, _elem.scaledtop, _elem.scaledwidth, _elem.scaledheight);
      }
    }

    _detectMoveAutoGuidelines(rect);

    _wasMoving = true;
    _hideAnchors();
  }

  void _stopMove(MouseEvent event) {
    hideAutoGuidelines();

    style.cursor = "default";

    _wasMoving = false;
    _showAnchors();

    _moveStartPt = null;
    if (_mousemove != null) {
      _mousemove.cancel();
      _mousemove = null;
    }
    if (_mouseup != null) {
      _mouseup.cancel();
      _mouseup = null;
    }
    if (_mouseout != null) {
      _mouseout.cancel();
      _mouseout = null;
    }
    if (_moveEscape != null) {
      _moveEscape.cancel();
      _moveEscape = null;
    }
  }

  /* Element resize */

  AnchorStream _nwStreams, _neStreams, _swStreams, _seStreams;
  AnchorStream _nStreams, _sStreams, _wStreams, _eStreams;

  void _dummyHandler(MouseEvent event) {
    event.stopPropagation(); //prevent element deselection when anchors are clicked
  }

  void _resizeEscapeHandler(KeyboardEvent event, AnchorStream arg_stream) {
    StageElement selectedEl = _selected.first;
    if (event.keyCode == KeyCode.ESC) {
      selectedEl.left = (arg_stream.initRect.left) ~/ stagescale;
      selectedEl.top = (arg_stream.initRect.top) ~/ stagescale;
      selectedEl.width = (arg_stream.initRect.width) ~/ stagescale;
      selectedEl.height = (arg_stream.initRect.height) ~/ stagescale;
      _cancelResize(null);
    }
  }

  void _nwResizeHandler(MouseEvent event) {
    print("nw resizing");
    StageElement selectedEl = _selected.first;
    _wasResizing = true;
    _hideAnchors();
    Point diff = event.page - _nwStreams.startPoint;
    num elW = _nwStreams.initRect.width - diff.x;
    num elH = _nwStreams.initRect.height - diff.y;
    if (getBoundingClientRect().containsPoint(event.page) && elW > 0 && elH > 0) {
      selectedEl.left = (_nwStreams.initRect.left + diff.x) ~/ stagescale;
      selectedEl.top = (_nwStreams.initRect.top + diff.y) ~/ stagescale;
      selectedEl.width = (_nwStreams.initRect.width - diff.x) ~/ stagescale;
      selectedEl.height = (_nwStreams.initRect.height - diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(selectedEl.scaledleft, selectedEl.scaledtop, selectedEl.scaledwidth, selectedEl.scaledheight);

    _detectResizeNWAutoGuidelines(rect);
  }

  void _neResizeHandler(MouseEvent event) {
    print("ne resizing");
    StageElement selectedEl = _selected.first;
    _wasResizing = true;
    _hideAnchors();
    Point diff = event.page - _neStreams.startPoint;
    num elW = _neStreams.initRect.width + diff.x;
    num elH = _neStreams.initRect.height - diff.y;
    if (getBoundingClientRect().containsPoint(event.page) && elW > 0 && elH > 0) {
      selectedEl.top = (_neStreams.initRect.top + diff.y) ~/ stagescale;
      selectedEl.width = (_neStreams.initRect.width + diff.x) ~/ stagescale;
      selectedEl.height = (_neStreams.initRect.height - diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(selectedEl.scaledleft, selectedEl.scaledtop, selectedEl.scaledwidth, selectedEl.scaledheight);

    _detectResizeNEAutoGuidelines(rect);
  }

  void _seResizeHandler(MouseEvent event) {
    print("se resizing");
    StageElement selectedEl = _selected.first;
    _wasResizing = true;
    _hideAnchors();
    Point diff = event.page - _seStreams.startPoint;
    num elW = _seStreams.initRect.width + diff.x;
    num elH = _seStreams.initRect.height + diff.y;
    if (getBoundingClientRect().containsPoint(event.page) && elW > 0 && elH > 0) {
      selectedEl.width = (_seStreams.initRect.width + diff.x) ~/ stagescale;
      selectedEl.height = (_seStreams.initRect.height + diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(selectedEl.scaledleft, selectedEl.scaledtop, selectedEl.scaledwidth, selectedEl.scaledheight);

    _detectResizeSEAutoGuidelines(rect);
  }

  void _swResizeHandler(MouseEvent event) {
    print("sw resizing");
    StageElement selectedEl = _selected.first;
    _wasResizing = true;
    _hideAnchors();
    Point diff = event.page - _swStreams.startPoint;
    num elW = _swStreams.initRect.width - diff.x;
    num elH = _swStreams.initRect.height + diff.y;
    if (getBoundingClientRect().containsPoint(event.page) && elW > 0 && elH > 0) {
      selectedEl.left = (_swStreams.initRect.left + diff.x) ~/ stagescale;
      selectedEl.width = (_swStreams.initRect.width - diff.x) ~/ stagescale;
      selectedEl.height = (_swStreams.initRect.height + diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(selectedEl.scaledleft, selectedEl.scaledtop, selectedEl.scaledwidth, selectedEl.scaledheight);

    _detectResizeSWAutoGuidelines(rect);
  }

  void _nResizeHandler(MouseEvent event) {
    print("n resizing");
    StageElement selectedEl = _selected.first;
    _wasResizing = true;
    _hideAnchors();
    Point diff = event.page - _nStreams.startPoint;
    num elH = _nStreams.initRect.height - diff.y;
    if (getBoundingClientRect().containsPoint(event.page) && elH > 0) {
      selectedEl.top = (_nStreams.initRect.top + diff.y) ~/ stagescale;
      selectedEl.height = (_nStreams.initRect.height - diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(selectedEl.scaledleft, selectedEl.scaledtop, selectedEl.scaledwidth, selectedEl.scaledheight);

    _detectResizeNAutoGuidelines(rect);
  }

  void _wResizeHandler(MouseEvent event) {
    print("w resizing");
    StageElement selectedEl = _selected.first;
    _wasResizing = true;
    _hideAnchors();
    Point diff = event.page - _wStreams.startPoint;
    num elW = _wStreams.initRect.width - diff.x;
    if (getBoundingClientRect().containsPoint(event.page) && elW > 0) {
      selectedEl.left = (_wStreams.initRect.left + diff.x) ~/ stagescale;
      selectedEl.width = (_wStreams.initRect.width - diff.x) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(selectedEl.scaledleft, selectedEl.scaledtop, selectedEl.scaledwidth, selectedEl.scaledheight);

    _detectResizeWAutoGuidelines(rect);
  }

  void _sResizeHandler(MouseEvent event) {
    print("s resizing");
    StageElement selectedEl = _selected.first;
    _wasResizing = true;
    _hideAnchors();
    Point diff = event.page - _sStreams.startPoint;
    num elH = _sStreams.initRect.height + diff.y;
    if (getBoundingClientRect().containsPoint(event.page) && elH > 0) {
      selectedEl.height = (_sStreams.initRect.height + diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(selectedEl.scaledleft, selectedEl.scaledtop, selectedEl.scaledwidth, selectedEl.scaledheight);

    _detectResizeSAutoGuidelines(rect);
  }

  void _eResizeHandler(MouseEvent event) {
    print("e resizing");
    StageElement selectedEl = _selected.first;
    _wasResizing = true;
    _hideAnchors();
    Point diff = event.page - _eStreams.startPoint;
    num elW = _eStreams.initRect.width + diff.x;
    if (getBoundingClientRect().containsPoint(event.page) && elW > 0) {
      selectedEl.width = (_eStreams.initRect.width + diff.x) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(selectedEl.scaledleft, selectedEl.scaledtop, selectedEl.scaledwidth, selectedEl.scaledheight);

    _detectResizeEAutoGuidelines(rect);
  }

  void _resizeMDHandler(MouseEvent event) {
    if (event.button == 0) {
      AnchorStream curTget;
      Function mouseMoveHandler;
      if (event.target == _anchornw) {
        curTget = _nwStreams;
        mouseMoveHandler = _nwResizeHandler;
      } else if (event.target == _anchorne) {
        curTget = _neStreams;
        mouseMoveHandler = _neResizeHandler;
      } else if (event.target == _anchorse) {
        curTget = _seStreams;
        mouseMoveHandler = _seResizeHandler;
      } else if (event.target == _anchorsw) {
        curTget = _swStreams;
        mouseMoveHandler = _swResizeHandler;
      } else if (event.target == _anchorn) {
        curTget = _nStreams;
        mouseMoveHandler = _nResizeHandler;
      } else if (event.target == _anchors) {
        curTget = _sStreams;
        mouseMoveHandler = _sResizeHandler;
      } else if (event.target == _anchorw) {
        curTget = _wStreams;
        mouseMoveHandler = _wResizeHandler;
      } else if (event.target == _anchore) {
        curTget = _eStreams;
        mouseMoveHandler = _eResizeHandler;
      }

      if (curTget != null) {
        StageElement selectedEl = _selected.first;

        print("${curTget.cursor} begin");
        Rectangle initRect = new Rectangle(selectedEl.offsetLeft, selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
        Point startPoint = event.page;
        style.cursor = curTget.cursor;

        StreamSubscription _nwMouseMove = onMouseMove.listen(mouseMoveHandler);
        StreamSubscription _nwMouseUp = onMouseUp.listen(_cancelResize);
        StreamSubscription _nwMouseOver = onMouseOut.listen(_cancelResize);
        StreamSubscription _nwKeyDown = document.onKeyDown.listen((KeyboardEvent ke) => _resizeEscapeHandler(ke, curTget));

        curTget.activate(initRect, startPoint, _nwMouseMove, _nwMouseUp, _nwMouseOver, _nwKeyDown);
      }

      event.stopImmediatePropagation();
      event.stopPropagation();
    }
  }

  void _setupResizeHandler() {
    //prevent element deselection when anchors are clicked
    _anchornw.onClick.listen(_dummyHandler);
    _anchorne.onClick.listen(_dummyHandler);
    _anchorsw.onClick.listen(_dummyHandler);
    _anchorse.onClick.listen(_dummyHandler);

    _anchorn.onClick.listen(_dummyHandler);
    _anchore.onClick.listen(_dummyHandler);
    _anchorw.onClick.listen(_dummyHandler);
    _anchors.onClick.listen(_dummyHandler);

    _nwStreams = new AnchorStream("nw-resize");
    _neStreams = new AnchorStream("ne-resize");
    _seStreams = new AnchorStream("se-resize");
    _swStreams = new AnchorStream("sw-resize");
    _nStreams = new AnchorStream("n-resize");
    _wStreams = new AnchorStream("w-resize");
    _eStreams = new AnchorStream("e-resize");
    _sStreams = new AnchorStream("s-resize");

    _selStream = new AnchorStream("crosshair");

    _anchornw.onMouseDown.listen(_resizeMDHandler);
    _anchorne.onMouseDown.listen(_resizeMDHandler);
    _anchorse.onMouseDown.listen(_resizeMDHandler);
    _anchorsw.onMouseDown.listen(_resizeMDHandler);
    _anchorn.onMouseDown.listen(_resizeMDHandler);
    _anchorw.onMouseDown.listen(_resizeMDHandler);
    _anchors.onMouseDown.listen(_resizeMDHandler);
    _anchore.onMouseDown.listen(_resizeMDHandler);
  }

  bool _anchorShowing = false;
  bool _wasResizing = false;

  _cancelResize(MouseEvent event) {
    print("resize cancelled");

    hideAutoGuidelines();

    _nwStreams.deactivate();
    _neStreams.deactivate();
    _swStreams.deactivate();
    _seStreams.deactivate();
    _nStreams.deactivate();
    _wStreams.deactivate();
    _eStreams.deactivate();
    _sStreams.deactivate();

    _wasResizing = false;
    _showAnchors();
    style.cursor = "default";
  }

  void _showAnchors() {
    if (_selected.length == 1) {
      _anchorShowing = true;

      StageElement selectedEl = _selected.first;

      //Fix anchor position
      _anchornw.style.left = "${selectedEl.offsetLeft - 10}px";
      _anchornw.style.top = "${selectedEl.offsetTop - 10}px";

      _anchorne.style.left = "${selectedEl.offsetLeft + selectedEl.offsetWidth}px";
      _anchorne.style.top = "${selectedEl.offsetTop - 10}px";

      _anchorsw.style.left = "${selectedEl.offsetLeft - 10}px";
      _anchorsw.style.top = "${selectedEl.offsetTop + selectedEl.offsetHeight}px";

      _anchorse.style.left = "${selectedEl.offsetLeft + selectedEl.offsetWidth}px";
      _anchorse.style.top = "${selectedEl.offsetTop + selectedEl.offsetHeight}px";

      _anchorn.style.left = "${selectedEl.offsetLeft + (selectedEl.offsetWidth / 2) - 5}px";
      _anchorn.style.top = "${selectedEl.offsetTop - 10}px";

      _anchore.style.left = "${selectedEl.offsetLeft + selectedEl.offsetWidth + 1}px";
      _anchore.style.top = "${selectedEl.offsetTop + (selectedEl.offsetHeight / 2) - 5}px";

      _anchorw.style.left = "${selectedEl.offsetLeft - 10}px";
      _anchorw.style.top = "${selectedEl.offsetTop + (selectedEl.offsetHeight / 2) - 5}px";

      _anchors.style.left = "${selectedEl.offsetLeft + (selectedEl.offsetWidth / 2) - 5}px";
      _anchors.style.top = "${selectedEl.offsetTop + selectedEl.offsetHeight + 1}px";

      _anchornw.classes.add("show");
      _anchorne.classes.add("show");
      _anchorsw.classes.add("show");
      _anchorse.classes.add("show");
      _anchorn.classes.add("show");
      _anchors.classes.add("show");
      _anchore.classes.add("show");
      _anchorw.classes.add("show");
    } else {
      _hideAnchors();
    }
  }

  void _hideAnchors() {
    _anchornw.classes.remove("show");
    _anchorne.classes.remove("show");
    _anchorsw.classes.remove("show");
    _anchorse.classes.remove("show");
    _anchorn.classes.remove("show");
    _anchore.classes.remove("show");
    _anchorw.classes.remove("show");
    _anchors.classes.remove("show");

    _anchorShowing = false;
  }

  /*_showHideAnchors() {
    if (_selected.length == 1 && !_wasMoving && !_wasResizing) {
      _showAnchors();
    } else if (_anchorShowing) {
      _hideAnchors();
    }
  }*/

  /* Element operations - addition, removal, etc */
  DivElement _canvas;
  DivElement _parcanvas;

  /*
   * Adds an element to the stage
   */
  bool addElement(StageElement _elem) {
    bool ret = true;
    if (_elem != null) {
      _canvas.children.add(_elem);
      _elements.add(_elem);
      _elem._added(this);
    } else {
      ret = false;
    }
    return ret;
  }

  /*
   * Removes an element from the stage
   */
  bool removeElement(StageElement _elem) {
    bool ret = true;
    if (_elem != null && _canvas.children.contains(_elem)) {
      if (_elem.isSelected) {
        deselectElement(_elem);
      }
      _canvas.children.remove(_elem);
      _elements.remove(_elem);
      _elem._removed();
    } else {
      ret = false;
    }
    return ret;
  }

  void removeElements(List<StageElement> list_elem) {
    List<StageElement> listEl = list_elem;

    for (StageElement el in listEl) {
      removeElement(el);
    }
  }

  void removeAllElements() {
    List<StageElement> listEl = _elements;

    for (StageElement el in listEl) {
      removeElement(el);
    }
  }


  /* Zoom */
  /*
   * Zooms into the stage
   */
  void zoomIn() {
    stagescale = stagescale * 2;
  }

  /*
   * Zooms out of the stage
   */
  void zoomOut() {
    stagescale = stagescale / 2;
  }

  void cancelZoom() {
    stagescale = 1;
  }

  void fit() {

    int i = 0;
    while (offsetWidth < (scaledWidth) || offsetHeight < (scaledHeight)) {
      zoomOut();
    }

    scrollToCenter();
  }

  void scrollToCenter() {
    scrollLeft = scrollWidth ~/ 2;
    scrollTop = scrollHeight ~/ 2;
  }

  List<StageElement> _elements = new List<StageElement>();
  List<StageElement> get elements => _elements.toList(growable: false);

  Set<StageElement> _selected = new Set<StageElement>();
  List<StageElement> get selected => _selected.toList(growable: false);

  num get scaledWidth => stagewidth * stagescale;
  num get scaledHeight => stageheight * stagescale;

  /* Properties */
  @published
  num stagewidth = 0;

  @published
  num stageheight = 0;

  @published
  num stagescale = 1.0;

  @published
  String stagebgcolor = "rgb(255, 255, 255)";

  @published
  String stagebgimage = "url()";

  @published
  bool resizable = true;

  void stagewidthChanged() {
    _canvas.style.width = "${scaledWidth}px";
  }

  void stageheightChanged() {
    _canvas.style.height = "${scaledHeight}px";
  }

  void stagescaleChanged() {
    stagewidthChanged();

    stageheightChanged();

    for (StageElement elem in _elements) {
      elem.widthChanged();
      elem.heightChanged();
      elem.leftChanged();
      elem.topChanged();
    }

    _showAnchors();
  }

  void stagebgcolorChanged() {
    _canvas.style.backgroundColor = stagebgcolor;
  }

  void stagebgimageChanged() {
    _canvas.style.backgroundImage = stagebgimage;
  }

  void resizableChanged() {

  }

  EventStreamProvider<CustomEvent> _elementSelectedEventP = new EventStreamProvider<CustomEvent>("elementselected");
  Stream<CustomEvent> get onElementSelected => _elementSelectedEventP.forTarget(this);
  void fireElementSelectedEvent(StageElement stage_el) {
    var event = new CustomEvent("elementselected", canBubble: false, cancelable: false, detail: stage_el);
    dispatchEvent(event);
  }


  EventStreamProvider<CustomEvent> _elementDeselectedEventP = new EventStreamProvider<CustomEvent>("elementdeselected");
  Stream<CustomEvent> get onElementDeselected => _elementDeselectedEventP.forTarget(this);
  void fireElementDeselectedEvent(StageElement stage_el) {
    var event = new CustomEvent("elementdeselected", canBubble: false, cancelable: false, detail: stage_el);
    dispatchEvent(event);
  }

  EventStreamProvider<CustomEvent> _allElementsDeselectedEventP = new EventStreamProvider<CustomEvent>("allelementsdeselected");
  Stream<CustomEvent> get onAllElementDeselected => _allElementsDeselectedEventP.forTarget(this);
  void fireAllElementsDeselectedEvent() {
    var event = new CustomEvent("allelementsdeselected", canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }
}
