@HtmlImport('stage.html')
@HtmlImport("stage_element.html")
library dockable.stage;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'dart:math';

part 'anchor_stream.dart';
part 'stage_element.dart';
part 'stageel_info.dart';
part 'guideline_helpers.dart';

/*
 * TODO:
 * implement stage resize
 * Implement delete
 * Implement anchor guidelines for Gap, Width, Height
 * Implement element rotation
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

  DockStage.created() : super.created() {}

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

    _thisObserver = new MutationObserver(_onThisMutation);
    _thisObserver.observe(this, childList: true);

    _canvas = shadowRoot.querySelector("#real-canvas");
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

    /*TODO: implement delete 
    onKeyDown.listen((KeyboardEvent ke) {
      
    });*/

    _setupResizeHandler();
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

  @published
  String bgcolor = "rgba(255, 255, 255, 1)";

  @published
  String bgimage = "";

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
    if (realTarget != null) {
      StageElement target = realTarget;
      if (multi) {
        if (_selected.contains(target)) {
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
        Point startPoint = event.offset + new Point(scrollLeft, scrollTop);

        Point leftTop = startPoint - _canvas.offset.topLeft;
        _groupSel.style.left = "${leftTop.x}px";
        _groupSel.style.top = "${leftTop.y}px";
        _groupSel.style.width = "0px";
        _groupSel.style.height = "0px";

        _groupSel.classes.add("show");

        StreamSubscription selMMove = onMouseMove.listen((MouseEvent event) {
          //print("here");
          Point selStartPt = _selStream.initRect - _canvas.offset.topLeft;
          Point selEndPt = event.offset +
              new Point(scrollLeft, scrollTop) -
              _canvas.offset.topLeft;

          Rectangle selRectangle =
              new Rectangle.fromPoints(selStartPt, selEndPt);
          style.cursor = "crosshair";
          _groupSel.style.left = "${selRectangle.left}px";
          _groupSel.style.top = "${selRectangle.top}px";
          _groupSel.style.width = "${selRectangle.width}px";
          _groupSel.style.height = "${selRectangle.height}px";
        });
        StreamSubscription selMUp = onMouseUp.listen((MouseEvent mpe) {
          Point selEndPt = mpe.client;
          Rectangle selRectangle =
              new Rectangle.fromPoints(_selStream.startPoint, selEndPt);
          deselectAllElements();
          for (StageElement _elem in _elements) {
            if (_elem.getBoundingClientRect().intersects(selRectangle)) {
              selectElement(_elem);
            }
          }
          _cancelSelRegion();
        });
        //StreamSubscription selMOut = onMouseOut.listen((MouseEvent mpe) => _cancelSelRegion());
        StreamSubscription selMOut = onMouseOut.listen((MouseEvent mpe) {});
        StreamSubscription selKDown = onKeyDown.listen((KeyboardEvent kbe) {
          if (kbe.keyCode == KeyCode.ESC) {
            _cancelSelRegion();
          }
        });

        _selStream.activate(
            startPoint, event.client, selMMove, selMUp, selMOut, selKDown);
      }
    }
  }

  void _cancelSelRegion() {
    _groupSel.classes.remove("show");
    _selStream.deactivate();
    style.cursor = "default";
  }

  void selectElement(StageElement _elem) {
    if (_elem.selectable && !_selected.contains(_elem)) {
      _selected.add(_elem);
      _fireSelectionChangedEvent();
    }
    _showAnchors();
  }

  void deselectElement(StageElement _elem) {
    if (_selected.contains(_elem)) {
      _selected.remove(_elem);
      _fireSelectionChangedEvent();
    }
    _showAnchors();
  }

  void deselectAllElements() {
    _selected.clear();
    _hideAnchors();
    _fireSelectionChangedEvent();
  }

  void showAutoGuidelines(Point a_glines) {
    if (a_glines.x != null) {
      _verAutoGL.classes.add("show");
      _verAutoGL.style.left = "${a_glines.x}px";
    } else {
      _verAutoGL.classes.remove("show");
    }

    if (a_glines.y != null) {
      _horAutoGL.classes.add("show");
      _horAutoGL.style.top = "${a_glines.y}px";
    } else {
      _horAutoGL.classes.remove("show");
    }
  }

  void hideAutoGuidelines() {
    _verAutoGL.classes.remove("show");
    _horAutoGL.classes.remove("show");
  }

  Point _moveStartPt;
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
          for (StageElement _elem in _selected) {
            StageElInfo b_elinfo = _infoMap[_elem];

            _elem.left = b_elinfo.posBeforeMove.x / stagescale;
            _elem.top = b_elinfo.posBeforeMove.y / stagescale;
          }
          _stopMove(null);
        }
      });
      _moveStartPt = event.page;

      for (StageElement _elem in _selected) {
        StageElInfo b_elinfo = _infoMap[_elem];
        b_elinfo.posBeforeMove =
            new Point(getScaledValue(_elem.left), getScaledValue(_elem.top));
      }
    }
  }

  void _processMove(MouseEvent event) {
    Rectangle rect;

    style.cursor = "move";

    int lowestLeft;
    int highestRight;
    int lowestTop;
    int highestBottom;

    if (getBoundingClientRect().containsPoint(event.page)) {
      Point diff = event.page - _moveStartPt;
      for (StageElement _elem in _selected) {
        StageElInfo b_elinfo = _infoMap[_elem];
        int left = (b_elinfo.posBeforeMove.x + diff.x) ~/ stagescale;
        int top = (b_elinfo.posBeforeMove.y + diff.y) ~/ stagescale;

        _elem.left = left;
        _elem.top = top;

        if (lowestLeft == null || lowestLeft > getScaledValue(_elem.left)) {
          lowestLeft = getScaledValue(_elem.left);
        }

        if (lowestTop == null || lowestTop > getScaledValue(_elem.top)) {
          lowestTop = getScaledValue(_elem.top);
        }

        if (highestRight == null ||
            highestRight <
                getScaledValue(_elem.left) + getScaledValue(_elem.width)) {
          highestRight =
              getScaledValue(_elem.left) + getScaledValue(_elem.width);
        }

        if (highestBottom == null ||
            highestBottom < getScaledValue(_elem.top) + _elem.scrollHeight) {
          highestBottom = getScaledValue(_elem.top) + _elem.scrollHeight;
        }
      }
    }

    rect = new Rectangle.fromPoints(new Point(lowestLeft, lowestTop),
        new Point(highestRight, highestBottom));
    Point l_glines = detectMoveAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);

    showAutoGuidelines(l_glines);

    _hideAnchors();
  }

  void _stopMove(MouseEvent event) {
    hideAutoGuidelines();

    style.cursor = "default";

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
    event
        .stopPropagation(); //prevent element deselection when anchors are clicked
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
    _hideAnchors();
    Point diff = event.page - _nwStreams.startPoint;
    num elW = _nwStreams.initRect.width - diff.x;
    num elH = _nwStreams.initRect.height - diff.y;
    if (getBoundingClientRect().containsPoint(event.page) &&
        elW > 0 &&
        elH > 0) {
      selectedEl.left = (_nwStreams.initRect.left + diff.x) ~/ stagescale;
      selectedEl.top = (_nwStreams.initRect.top + diff.y) ~/ stagescale;
      selectedEl.width = (_nwStreams.initRect.width - diff.x) ~/ stagescale;
      selectedEl.height = (_nwStreams.initRect.height - diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(getScaledValue(selectedEl.left),
        getScaledValue(selectedEl.top), getScaledValue(selectedEl.width),
        getScaledValue(selectedEl.height));

    Point l_glines = detectResizeNWAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);

    showAutoGuidelines(l_glines);
  }

  void _neResizeHandler(MouseEvent event) {
    print("ne resizing");
    StageElement selectedEl = _selected.first;
    _hideAnchors();
    Point diff = event.page - _neStreams.startPoint;
    num elW = _neStreams.initRect.width + diff.x;
    num elH = _neStreams.initRect.height - diff.y;
    if (getBoundingClientRect().containsPoint(event.page) &&
        elW > 0 &&
        elH > 0) {
      selectedEl.top = (_neStreams.initRect.top + diff.y) ~/ stagescale;
      selectedEl.width = (_neStreams.initRect.width + diff.x) ~/ stagescale;
      selectedEl.height = (_neStreams.initRect.height - diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(getScaledValue(selectedEl.left),
        getScaledValue(selectedEl.top), getScaledValue(selectedEl.width),
        getScaledValue(selectedEl.height));

    Point l_glines = detectResizeNEAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);
    showAutoGuidelines(l_glines);
  }

  void _seResizeHandler(MouseEvent event) {
    print("se resizing");
    StageElement selectedEl = _selected.first;
    _hideAnchors();
    Point diff = event.page - _seStreams.startPoint;
    num elW = _seStreams.initRect.width + diff.x;
    num elH = _seStreams.initRect.height + diff.y;
    if (getBoundingClientRect().containsPoint(event.page) &&
        elW > 0 &&
        elH > 0) {
      selectedEl.width = (_seStreams.initRect.width + diff.x) ~/ stagescale;
      selectedEl.height = (_seStreams.initRect.height + diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(getScaledValue(selectedEl.left),
        getScaledValue(selectedEl.top), getScaledValue(selectedEl.width),
        getScaledValue(selectedEl.height));

    Point l_glines = detectResizeSEAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);
    showAutoGuidelines(l_glines);
  }

  void _swResizeHandler(MouseEvent event) {
    print("sw resizing");
    StageElement selectedEl = _selected.first;
    _hideAnchors();
    Point diff = event.page - _swStreams.startPoint;
    num elW = _swStreams.initRect.width - diff.x;
    num elH = _swStreams.initRect.height + diff.y;
    if (getBoundingClientRect().containsPoint(event.page) &&
        elW > 0 &&
        elH > 0) {
      selectedEl.left = (_swStreams.initRect.left + diff.x) ~/ stagescale;
      selectedEl.width = (_swStreams.initRect.width - diff.x) ~/ stagescale;
      selectedEl.height = (_swStreams.initRect.height + diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(getScaledValue(selectedEl.left),
        getScaledValue(selectedEl.top), getScaledValue(selectedEl.width),
        getScaledValue(selectedEl.height));

    Point l_glines = detectResizeSWAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);
    showAutoGuidelines(l_glines);
  }

  void _nResizeHandler(MouseEvent event) {
    print("n resizing");
    StageElement selectedEl = _selected.first;
    _hideAnchors();
    Point diff = event.page - _nStreams.startPoint;
    num elH = _nStreams.initRect.height - diff.y;
    if (getBoundingClientRect().containsPoint(event.page) && elH > 0) {
      selectedEl.top = (_nStreams.initRect.top + diff.y) ~/ stagescale;
      selectedEl.height = (_nStreams.initRect.height - diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(getScaledValue(selectedEl.left),
        getScaledValue(selectedEl.top), getScaledValue(selectedEl.width),
        getScaledValue(selectedEl.height));

    Point l_glines = detectResizeNAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);
    showAutoGuidelines(l_glines);
  }

  void _wResizeHandler(MouseEvent event) {
    print("w resizing");
    StageElement selectedEl = _selected.first;
    _hideAnchors();
    Point diff = event.page - _wStreams.startPoint;
    num elW = _wStreams.initRect.width - diff.x;
    if (getBoundingClientRect().containsPoint(event.page) && elW > 0) {
      selectedEl.left = (_wStreams.initRect.left + diff.x) ~/ stagescale;
      selectedEl.width = (_wStreams.initRect.width - diff.x) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(getScaledValue(selectedEl.left),
        getScaledValue(selectedEl.top), getScaledValue(selectedEl.width),
        getScaledValue(selectedEl.height));

    Point l_glines = detectResizeWAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);
    showAutoGuidelines(l_glines);
  }

  void _sResizeHandler(MouseEvent event) {
    print("s resizing");
    StageElement selectedEl = _selected.first;
    _hideAnchors();
    Point diff = event.page - _sStreams.startPoint;
    num elH = _sStreams.initRect.height + diff.y;
    if (getBoundingClientRect().containsPoint(event.page) && elH > 0) {
      selectedEl.height = (_sStreams.initRect.height + diff.y) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(getScaledValue(selectedEl.left),
        getScaledValue(selectedEl.top), getScaledValue(selectedEl.width),
        getScaledValue(selectedEl.height));

    Point l_glines = detectResizeSAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);
    showAutoGuidelines(l_glines);
  }

  void _eResizeHandler(MouseEvent event) {
    print("e resizing");
    StageElement selectedEl = _selected.first;
    _hideAnchors();
    Point diff = event.page - _eStreams.startPoint;
    num elW = _eStreams.initRect.width + diff.x;
    if (getBoundingClientRect().containsPoint(event.page) && elW > 0) {
      selectedEl.width = (_eStreams.initRect.width + diff.x) ~/ stagescale;
    }

    //TODO: for detectAnchorPoints find bounding rectangle of all selected elements
    Rectangle rect = new Rectangle(getScaledValue(selectedEl.left),
        getScaledValue(selectedEl.top), getScaledValue(selectedEl.width),
        getScaledValue(selectedEl.height));

    Point l_glines = detectResizeEAutoGuidelines(
        rect, new Point(scaledWidth, scaledHeight), _elements, _selected);
    showAutoGuidelines(l_glines);
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

        //print("${curTget.cursor} begin");
        Rectangle initRect = new Rectangle(selectedEl.offsetLeft,
            selectedEl.offsetTop, selectedEl.offsetWidth,
            selectedEl.offsetHeight);
        Point startPoint = event.page;
        style.cursor = curTget.cursor;

        StreamSubscription _nwMouseMove = onMouseMove.listen(mouseMoveHandler);
        StreamSubscription _nwMouseUp = onMouseUp.listen(_cancelResize);
        //StreamSubscription _nwMouseOver = onMouseOut.listen(_cancelResize);
        StreamSubscription _nwMouseOver = onMouseOut.listen((_) {});
        StreamSubscription _nwKeyDown = document.onKeyDown
            .listen((KeyboardEvent ke) => _resizeEscapeHandler(ke, curTget));

        curTget.activate(initRect, startPoint, _nwMouseMove, _nwMouseUp,
            _nwMouseOver, _nwKeyDown);
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

    _showAnchors();
    style.cursor = "default";
  }

  @observable
  num selLeft = 0;
  @observable
  num selTop = 0;
  @observable
  num selWidth = 0;
  @observable
  num selHeight = 0;
  @observable
  num selHorCenter = 0;
  @observable
  num selVerCenter = 0;

  @observable
  bool showAnchors = false;

  void _showAnchors() {
    if (_selected.length == 1) {
      StageElement selectedEl = _selected.first;

      selLeft = getScaledValue(selectedEl.left);
      selTop = getScaledValue(selectedEl.top);
      selWidth =
          getScaledValue(selectedEl.left) + getScaledValue(selectedEl.width);
      selHeight =
          getScaledValue(selectedEl.top) + getScaledValue(selectedEl.height);

      selHorCenter = getScaledValue(selectedEl.left) +
          (getScaledValue(selectedEl.width) / 2);
      selVerCenter = getScaledValue(selectedEl.top) +
          (getScaledValue(selectedEl.height) / 2);

      showAnchors = true;
    } else {
      _hideAnchors();
    }
  }

  void _hideAnchors() {
    showAnchors = false;
  }

  DivElement _canvas;
  DivElement _parcanvas;

  MutationObserver _thisObserver;
  void _onThisMutation(records, observer) {
    //dataChanged();
    for (MutationRecord record in records) {
      for (Node node in record.addedNodes) {
        if (node is StageElement) {
          StageElement b_stg_el = node;
          _elements.add(node);
          _updateElementPos(node);

          StageElInfo b_elinfo = new StageElInfo();
          b_elinfo.element = b_stg_el;

          b_elinfo.movedStream = b_stg_el.onMoved.listen((_) {
            _updateElementPos(b_stg_el);
          });
          b_elinfo.resizedStream = b_stg_el.onResized.listen((_) {
            _updateElementPos(b_stg_el);
          });

          _infoMap[b_stg_el] = b_elinfo;
        }
      }
      for (Node node in record.removedNodes) {
        if (node is StageElement) {
          deselectElement(node);
          _elements.remove(node);
          StageElInfo b_elinfo = _infoMap.remove(node);
          b_elinfo.movedStream.cancel();
          b_elinfo.resizedStream.cancel();
        }
      }
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

  Map<StageElement, StageElInfo> _infoMap =
      new Map<StageElement, StageElInfo>();

  Set<StageElement> _selected = new Set<StageElement>();
  List<StageElement> get selected => _selected.toList(growable: false);

  num get scaledWidth {
    if(stagewidth != null && stagescale != null) {
      return stagewidth * stagescale;
    } else {
      return 0;
    }
  } 
  num get scaledHeight {
    if(stageheight != null && stagescale != null) {
      return stageheight * stagescale;
    }else {
      return 0;
    }
  }

  /* Properties */
  @published
  num stagewidth = 0;

  @published
  num stageheight = 0;

  @published
  num stagescale = 1.0;

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
      _updateElementPos(elem);
    }

    _showAnchors();
  }

  void resizableChanged() {}

  int getScaledValue(num a_inp) {
    return (a_inp * stagescale).toInt();
  }

  void _updateElementPos(StageElement a_elem) {
    a_elem.style.width = "${getScaledValue(a_elem.width)}px";
    a_elem.style.height = "${getScaledValue(a_elem.height)}px";
    a_elem.style.left = "${getScaledValue(a_elem.left)}px";
    a_elem.style.top = "${getScaledValue(a_elem.top)}px";
  }

  EventStreamProvider<CustomEvent> _selChangedEventP =
      new EventStreamProvider<CustomEvent>("selection-changed");
  Stream<CustomEvent> get onSelectionChanged =>
      _selChangedEventP.forTarget(this);
  void _fireSelectionChangedEvent() {
    var event = new CustomEvent("selection-changed",
        canBubble: false, cancelable: false);
    dispatchEvent(event);
  }
}
