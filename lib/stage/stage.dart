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
 * Implement anchor guidelines when moving and resizing
 * Implement north, south, east, west resizing 
 */

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

  DivElement _verAutoGL;
  DivElement _horAutoGL;

  @override
  void ready() {
    super.ready();

    _canvas = shadowRoot.querySelector("#canvas");
    assert(_canvas != null);

    _parcanvas = shadowRoot.querySelector("#canvas-parent");
    assert(_parcanvas != null);

    _anchornw = shadowRoot.querySelector(".anchor-nw");
    assert(_anchornw != null);

    _anchorne = shadowRoot.querySelector(".anchor-ne");
    assert(_anchorne != null);

    _anchorsw = shadowRoot.querySelector(".anchor-sw");
    assert(_anchorsw != null);

    _anchorse = shadowRoot.querySelector(".anchor-se");
    assert(_anchorse != null);

    _verAutoGL = shadowRoot.querySelector("#ver-auto-gline");
    _horAutoGL = shadowRoot.querySelector("#hor-auto-gline");

    for (HtmlElement child in children) {
      child.remove();
      if (child is StageElement) {
        addElement(child);
      }
    }

    _clicksub = onClick.listen(_stageClicked);

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
    /*if (_clicksub != null) {
      _clicksub.cancel();
      _clicksub = null;
    }

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
    }*/
  }

  StreamSubscription _clicksub;
  StreamSubscription _mouseout, _mousemove, _mouseup;
  StreamSubscription _moveEscape;


  /* Element selection */
  void _stageClicked(MouseEvent event) {
    //Don't do selection at the end of move and resize
    if (_wasMoving) {
      _wasMoving = false;
      _showHideAnchors();
      return;
    }
    if (_wasResizing) {
      _wasResizing = false;
      _showHideAnchors();
      return;
    }

    bool multi = event.shiftKey;
    if (_elements.contains(event.target)) {
      StageElement target = event.target;
      if (multi) {
        if (target.isSelected) {
          deselectElement(target);
        } else {
          if (target.selectable) {
            selectElement(target);
          }
        }
      } else {
        deselectAllElements();
        if (target.selectable) {
          selectElement(target);
        }
      }
    } else {
      deselectAllElements();
    }

  }

  void selectElement(StageElement _elem) {
    if (_elem.selectable && !_elem.isSelected) {
      _selected.add(_elem);
      _elem._selected();
      fireElementSelectedEvent(_elem);
    }
    _showHideAnchors();
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
    _showHideAnchors();
  }

  void deselectAllElements() {
    _selected.forEach((StageElement _elem) {
      _elem._deselected();
      fireElementDeselectedEvent(_elem);
    });
    _selected.clear();
    fireAllElementsDeselectedEvent();
    _showHideAnchors();
  }

  /* Move */
  Point _moveStartPt;
  bool _wasMoving = false;

  Point detectAutoGuidelines(Rectangle rect) {

    int vertAnchor;
    int horAnchor;
    //TODO: also find equal gaps

    //print(rect);

    int lmiddle = rect.left + (rect.width ~/ 2);
    //middle
    if (lmiddle == scaledWidth ~/ 2) {
      vertAnchor = lmiddle;
    }
    for (StageElement _elem in _elements) {
      if (!_selected.contains(_elem)) {
        int elmid = _elem.offset.left + (_elem.offsetWidth ~/ 2);
        if (lmiddle == elmid) {
          vertAnchor = lmiddle;
        }
      }
    }

    if (vertAnchor == null) {
      //left
      if (rect.left == 0) {
        vertAnchor = rect.left;
      } else if (rect.left == scaledWidth) {
        vertAnchor = rect.left;
      }
      for (StageElement _elem in _elements) {
        if (!_selected.contains(_elem)) {
          if (rect.left == _elem.offsetLeft) {
            vertAnchor = rect.left;
          }
        }
      }
    }

    if (vertAnchor == null) {
      //right
      if (rect.right == 0) {
        vertAnchor = rect.right;
      } else if (rect.right == scaledWidth) {
        vertAnchor = rect.right;
      }
      for (StageElement _elem in _elements) {
        if (!_selected.contains(_elem)) {
          if (rect.right == _elem.offset.right) {
            vertAnchor = rect.right;
          }
        }
      }
    }

    int tmiddle = rect.top + (rect.height ~/ 2);
    //middle
    if (tmiddle == scaledHeight ~/ 2) {
      horAnchor = tmiddle;
    }
    for (StageElement _elem in _elements) {
      if (!_selected.contains(_elem)) {
        int elmid = _elem.offset.top + (_elem.offsetHeight ~/ 2);
        if (tmiddle == elmid) {
          horAnchor = tmiddle;
        }
      }
    }

    if (horAnchor == null) {
      //left
      if (rect.top == 0) {
        horAnchor = rect.top;
      } else if (rect.top == scaledHeight) {
        horAnchor = rect.top;
      }
      for (StageElement _elem in _elements) {
        if (!_selected.contains(_elem)) {
          if (rect.top == _elem.offsetTop) {
            horAnchor = rect.top;
          }
        }
      }
    }

    if (horAnchor == null) {
      //bottom
      if (rect.bottom == 0) {
        horAnchor = rect.bottom;
      } else if (rect.bottom == scaledHeight) {
        horAnchor = rect.bottom;
      }
      for (StageElement _elem in _elements) {
        if (!_selected.contains(_elem)) {
          if (rect.bottom == _elem.offset.bottom) {
            horAnchor = rect.bottom;
          }
        }
      }
      print("${rect.bottom} ${scaledHeight}");
    }

    if (vertAnchor != null) {
      //print("vagl=${vertAnchor}");
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${vertAnchor}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    if (horAnchor != null) {
      //print("hagl=${horAnchor}");
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${horAnchor}px";
    } else {
      _horAutoGL.classes.remove("show");
    }


    print("-------");
    return new Point(vertAnchor, horAnchor);
  }

  void hideAutoGuidelines() {
    _verAutoGL.classes.remove("show");
    _horAutoGL.classes.remove("show");
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

    detectAutoGuidelines(rect);

    _wasMoving = true;
    _showHideAnchors();
  }

  void _stopMove(MouseEvent event) {
    hideAutoGuidelines();

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

  StreamSubscription _nwMD, _nwC;
  StreamSubscription _neMD, _neC;
  StreamSubscription _swMD, _swC;
  StreamSubscription _seMD, _seC;
  StreamSubscription _ancMM, _ancMU, _ancMO, _ancEsc;
  bool _anchorShowing = false;
  bool _wasResizing = false;

  _cancelResize(MouseEvent event) {
    print("resize cancelled");
    if (_ancMM != null) {
      _ancMM.cancel();
      _ancMM = null;
    }
    if (_ancMU != null) {
      _ancMU.cancel();
      _ancMU = null;
    }
    if (_ancEsc != null) {
      _ancEsc.cancel();
      _ancEsc = null;
    }
    if (_ancMO != null) {
      _ancMO.cancel();
      _ancMO = null;
    }
    //_wasResizing = false;
    //_showHideAnchors();
    style.cursor = "default";
  }

  _showHideAnchors() {
    if (_selected.length == 1 && !_wasMoving && !_wasResizing) {
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

      if (!_anchorShowing) {
        _anchorShowing = true;

        /* Northwest */
        _anchornw.classes.add("show");
        _nwMD = _anchornw.onMouseDown.listen((MouseEvent event) {
          if (event.button == 0) {
            print("nw resize begin");
            Rectangle initRect = new Rectangle(selectedEl.offsetLeft, selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
            Point startPoint = event.page;
            _ancMM = onMouseMove.listen((MouseEvent event) {
              print("nw resizing");

              _wasResizing = true;
              _showHideAnchors();
              Point diff = event.page - startPoint;
              num elW = initRect.width - diff.x;
              num elH = initRect.height - diff.y;
              if (getBoundingClientRect().containsPoint(event.page) && elW > 0 && elH > 0) {
                selectedEl.left = (initRect.left + diff.x) ~/ stagescale;
                selectedEl.top = (initRect.top + diff.y) ~/ stagescale;
                selectedEl.width = (initRect.width - diff.x) ~/ stagescale;
                selectedEl.height = (initRect.height - diff.y) ~/ stagescale;
              }
            });
            _ancMU = onMouseUp.listen(_cancelResize);
            _ancMO = onMouseOut.listen(_cancelResize);
            _ancEsc = document.onKeyDown.listen((KeyboardEvent event) {
              if (event.keyCode == KeyCode.ESC) {
                _cancelResize(null);
                selectedEl.left = (initRect.left) ~/ stagescale;
                selectedEl.top = (initRect.top) ~/ stagescale;
                selectedEl.width = (initRect.width) ~/ stagescale;
                selectedEl.height = (initRect.height) ~/ stagescale;
              }
            });
            style.cursor = "nw-resize";
          }
        }); //End of onMouseDown
        _nwC = _anchornw.onClick.listen((MouseEvent event) {
          //Stop propagation to prevent element deselection when
          //anchors are clicked
          event.stopPropagation();
        });

        /* Northeast */
        _anchorne.classes.add("show");
        _neMD = _anchorne.onMouseDown.listen((MouseEvent event) {
          if (event.button == 0) {
            print("ne resize begin");
            Rectangle initRect = new Rectangle(selectedEl.offsetLeft, selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
            Point startPoint = event.page;
            _ancMM = onMouseMove.listen((MouseEvent event) {
              print("ne resizing");
              _wasResizing = true;
              _showHideAnchors();
              Point diff = event.page - startPoint;
              num elW = initRect.width + diff.x;
              num elH = initRect.height - diff.y;
              if (getBoundingClientRect().containsPoint(event.page) && elW > 0 && elH > 0) {
                //selectedEl.left = initRect.left;
                selectedEl.top = (initRect.top + diff.y) ~/ stagescale;
                selectedEl.width = (initRect.width + diff.x) ~/ stagescale;
                selectedEl.height = (initRect.height - diff.y) ~/ stagescale;
              }
            });
            _ancMU = onMouseUp.listen(_cancelResize);
            _ancMO = onMouseOut.listen(_cancelResize);
            _ancEsc = document.onKeyDown.listen((KeyboardEvent event) {
              if (event.keyCode == KeyCode.ESC) {
                _cancelResize(null);
                //selectedEl.left = initRect.left;
                selectedEl.top = (initRect.top) ~/ stagescale;
                selectedEl.width = (initRect.width) ~/ stagescale;
                selectedEl.height = (initRect.height) ~/ stagescale;
              }
            });
            style.cursor = "ne-resize";
          }
        });
        _neC = _anchorne.onClick.listen((MouseEvent event) {
          //Stop propagation to prevent element deselection when
          //anchors are clicked
          event.stopPropagation();
        });


        /* Southwest */
        _anchorsw.classes.add("show");
        _swMD = _anchorsw.onMouseDown.listen((MouseEvent event) {
          if (event.button == 0) {
            print("sw resize begin");
            Rectangle initRect = new Rectangle(selectedEl.offsetLeft, selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
            Point startPoint = event.page;
            _ancMM = onMouseMove.listen((MouseEvent event) {
              print("sw resizing");
              _wasResizing = true;
              _showHideAnchors();
              Point diff = event.page - startPoint;
              num elW = initRect.width - diff.x;
              num elH = initRect.height + diff.y;
              if (getBoundingClientRect().containsPoint(event.page) && elW > 0 && elH > 0) {
                selectedEl.left = (initRect.left + diff.x) ~/ stagescale;
                //selectedEl.top = initRect.top;
                selectedEl.width = (initRect.width - diff.x) ~/ stagescale;
                selectedEl.height = (initRect.height + diff.y) ~/ stagescale;
              }
            });
            _ancMU = onMouseUp.listen(_cancelResize);
            _ancMO = onMouseOut.listen(_cancelResize);
            _ancEsc = document.onKeyDown.listen((KeyboardEvent event) {
              if (event.keyCode == KeyCode.ESC) {
                _cancelResize(null);
                selectedEl.left = (initRect.left) ~/ stagescale;
                //selectedEl.top = initRect.top;
                selectedEl.width = (initRect.width) ~/ stagescale;
                selectedEl.height = (initRect.height) ~/ stagescale;
              }
            });
            style.cursor = "sw-resize";
          }
        });
        _swC = _anchorsw.onClick.listen((MouseEvent event) {
          //Stop propagation to prevent element deselection when
          //anchors are clicked
          event.stopPropagation();
        });

        /* Southeast */
        _anchorse.classes.add("show");
        _seMD = _anchorse.onMouseDown.listen((MouseEvent event) {
          if (event.button == 0) {
            print("se resize begin");
            Rectangle initRect = new Rectangle(selectedEl.offsetLeft, selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
            Point startPoint = event.page;
            _ancMM = document.body.onMouseMove.listen((MouseEvent event) {
              print("se resizing");
              _wasResizing = true;
              _showHideAnchors();
              Point diff = event.page - startPoint;
              num elW = initRect.width + diff.x;
              num elH = initRect.height + diff.y;
              if (getBoundingClientRect().containsPoint(event.page) && elW > 0 && elH > 0) {
                //selectedEl.left = initRect.left +  diff.x;
                //selectedEl.top = initRect.top;
                selectedEl.width = (initRect.width + diff.x) ~/ stagescale;
                selectedEl.height = (initRect.height + diff.y) ~/ stagescale;
              }
            });
            _ancMU = document.body.onMouseUp.listen(_cancelResize);
            _ancMO = onMouseOut.listen(_cancelResize);
            _ancEsc = document.onKeyDown.listen((KeyboardEvent event) {
              if (event.keyCode == KeyCode.ESC) {
                _cancelResize(null);
                //selectedEl.left = initRect.left;
                //selectedEl.top = initRect.top;
                selectedEl.width = (initRect.width) ~/ stagescale;
                selectedEl.height = (initRect.height) ~/ stagescale;
              }
            });
            style.cursor = "se-resize";
          }
        });
        _seC = _anchorse.onClick.listen((MouseEvent event) {
          //Stop propagation to prevent element deselection when
          //anchors are clicked
          event.stopPropagation();
        });

      }

    } else if (_anchorShowing) {
      if (_nwMD != null) {
        _nwMD.cancel();
        _nwMD = null;
      }
      if (_neMD != null) {
        _neMD.cancel();
        _neMD = null;
      }
      if (_swMD != null) {
        _swMD.cancel();
        _swMD = null;
      }
      if (_seMD != null) {
        _seMD.cancel();
        _seMD = null;
      }

      if (_nwC != null) {
        _nwC.cancel();
        _nwC = null;
      }
      if (_neC != null) {
        _neC.cancel();
        _neC = null;
      }
      if (_swC != null) {
        _swC.cancel();
        _swC = null;
      }
      if (_seC != null) {
        _seC.cancel();
        _seC = null;
      }

      _anchornw.classes.remove("show");
      _anchorne.classes.remove("show");
      _anchorsw.classes.remove("show");
      _anchorse.classes.remove("show");

      _anchorShowing = false;
    }
  }

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

    _showHideAnchors();
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
