library stage;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';
import 'dart:math';

part 'stage_element.dart';

/*
 * TODO:
 * Implement select and deselect events
 * Fix scaling: elements are getting wrong size when scaled
 * implement stage resize
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

  DockStage.created(): super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Dockable.Stage');

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  DivElement _anchornw;
  DivElement _anchorne;
  DivElement _anchorsw;
  DivElement _anchorse;

  @override
  void ready() {
    super.ready();

    _canvas = this.shadowRoot.querySelector("#canvas");
    assert(_canvas != null);

    _anchornw = this.shadowRoot.querySelector(".anchor-nw");
    assert(_anchornw != null);

    _anchorne = this.shadowRoot.querySelector(".anchor-ne");
    assert(_anchorne != null);

    _anchorsw = this.shadowRoot.querySelector(".anchor-sw");
    assert(_anchorsw != null);

    _anchorse = this.shadowRoot.querySelector(".anchor-se");
    assert(_anchorse != null);

    for (HtmlElement child in children) {
      child.remove();
      if (child is StageElement) {
        addElement(child);
      }
    }

    _clicksub = onClick.listen(_stageClicked);

    onMouseWheel.listen((WheelEvent event) {
      if (event.ctrlKey && event.shiftKey) {
        if (event.wheelDeltaY < 0) {
          zoomOut();
        } else {
          zoomIn();
        }
      }
    });

    stagebgcolorChanged();
  }

  @override
  void enteredView() {
    super.enteredView();
  }

  @override
  void leftView() {
    super.leftView();
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

  /*
   * Called by the [StageElement] when the user starts to move
   */
  void _startMove(MouseEvent event) {
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

  void _processMove(MouseEvent event) {
    if (getBoundingClientRect().containsPoint(event.page)) {
      Point diff = event.page - _moveStartPt;
      for (StageElement _elem in _selected) {
        _elem.left = (_elem._savedPosBeforeMove.x + diff.x) / stagescale;
        _elem.top = (_elem._savedPosBeforeMove.y + diff.y) / stagescale;
      }
    }
    _wasMoving = true;
    _showHideAnchors();
  }

  void _stopMove(MouseEvent event) {
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
      _anchornw.style.left =
          "${selectedEl.offsetLeft - 5}px";
      _anchornw.style.top = "${selectedEl.offsetTop - 5}px";

      _anchorne.style.left =
          "${selectedEl.offsetLeft + selectedEl.offsetWidth}px";
      _anchorne.style.top = "${selectedEl.offsetTop - 5}px";

      _anchorsw.style.left =
          "${selectedEl.offsetLeft - 5}px";
      _anchorsw.style.top =
          "${selectedEl.offsetTop + selectedEl.offsetHeight}px";

      _anchorse.style.left =
          "${selectedEl.offsetLeft + selectedEl.offsetWidth}px";
      _anchorse.style.top =
          "${selectedEl.offsetTop + selectedEl.offsetHeight}px";

      if (!_anchorShowing) {
        _anchorShowing = true;

        /* Northwest */
        _anchornw.classes.add("show");
        _nwMD = _anchornw.onMouseDown.listen((MouseEvent event) {
          print("here");
          Rectangle initRect = new Rectangle(selectedEl.offsetLeft,
              selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
          Point startPoint = event.page;
          _ancMM = onMouseMove.listen((MouseEvent event) {
            _wasResizing = true;
            _showHideAnchors();
            Point diff = event.page - startPoint;
            num elW = initRect.width - diff.x;
            num elH = initRect.height - diff.y;
            if (getBoundingClientRect().containsPoint(event.page) && elW > 0 &&
                elH > 0) {
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
        }); //End of onMouseDown
        _nwC = _anchornw.onClick.listen((MouseEvent event) {
          //Stop propagation to prevent element deselection when
          //anchors are clicked
          event.stopPropagation();
        });

        /* Northeast */
        _anchorne.classes.add("show");
        _neMD = _anchorne.onMouseDown.listen((MouseEvent event) {
          Rectangle initRect = new Rectangle(selectedEl.offsetLeft,
              selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
          Point startPoint = event.page;
          _ancMM = onMouseMove.listen((MouseEvent event) {
            _wasResizing = true;
            _showHideAnchors();
            Point diff = event.page - startPoint;
            num elW = initRect.width + diff.x;
            num elH = initRect.height - diff.y;
            if (getBoundingClientRect().containsPoint(event.page) && elW > 0 &&
                elH > 0) {
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
        });
        _neC = _anchorne.onClick.listen((MouseEvent event) {
          //Stop propagation to prevent element deselection when
          //anchors are clicked
          event.stopPropagation();
        });


        /* Southwest */
        _anchorsw.classes.add("show");
        _swMD = _anchorsw.onMouseDown.listen((MouseEvent event) {
          Rectangle initRect = new Rectangle(selectedEl.offsetLeft,
              selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
          Point startPoint = event.page;
          _ancMM = onMouseMove.listen((MouseEvent event) {
            _wasResizing = true;
            _showHideAnchors();
            Point diff = event.page - startPoint;
            num elW = initRect.width - diff.x;
            num elH = initRect.height + diff.y;
            if (getBoundingClientRect().containsPoint(event.page) && elW > 0 &&
                elH > 0) {
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
        });
        _swC = _anchorsw.onClick.listen((MouseEvent event) {
          //Stop propagation to prevent element deselection when
          //anchors are clicked
          event.stopPropagation();
        });

        /* Southeast */
        _anchorse.classes.add("show");
        _seMD = _anchorse.onMouseDown.listen((MouseEvent event) {
          Rectangle initRect = new Rectangle(selectedEl.offsetLeft,
              selectedEl.offsetTop, selectedEl.offsetWidth, selectedEl.offsetHeight);
          Point startPoint = event.page;
          _ancMM = onMouseMove.listen((MouseEvent event) {
            _wasResizing = true;
            _showHideAnchors();
            Point diff = event.page - startPoint;
            num elW = initRect.width + diff.x;
            num elH = initRect.height + diff.y;
            if (getBoundingClientRect().containsPoint(event.page) && elW > 0 &&
                elH > 0) {
              //selectedEl.left = initRect.left +  diff.x;
              //selectedEl.top = initRect.top;
              selectedEl.width = (initRect.width + diff.x) ~/ stagescale;
              selectedEl.height = (initRect.height + diff.y) ~/ stagescale;
            }
          });
          _ancMU = onMouseUp.listen(_cancelResize);
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
        });
        _seC = _anchorse.onClick.listen((MouseEvent event) {
          //Stop propagation to prevent element deselection when
          //anchors are clicked
          event.stopPropagation();
        });

      }

    } else if (_anchorShowing) {
      //TODO: fix cancelling stream subscriptions
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
    stagescale = stagescale * 1.5;
  }

  /*
   * Zooms out of the stage
   */
  void zoomOut() {
    stagescale = stagescale * 0.666;
  }

  void cancelZoom() {
    stagescale = 1;
  }

  //TODO: implement fit
  /*void fit() {
    num xDiff = offsetWidth/stagewidth;
    num yDiff = offsetHeight/stageheight;

    num diff = xDiff < yDiff? xDiff : yDiff;
    if(diff > 1.5) {
      int nTimes = (log(diff) * 2.46630351).floor();
      stagescale = stagescale * pow(1.5, nTimes);
    } else if (diff < 0.666) {
      int nTimes = (log(diff) * 2.46630351).floor();
      stagescale = stagescale * pow(0.666, nTimes);
    }
  }*/

  List<StageElement> _elements = new List<StageElement>();
  List<StageElement> get elements => _elements.toList(growable: false);

  Set<StageElement> _selected = new Set<StageElement>();
  List<StageElement> get selected => _selected.toList(growable: false);

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
    _canvas.style.width = "${stagewidth * stagescale}px";
    //_canvas.style.marginLeft = "-${stagewidth * stagescale/2}px";
  }

  void stageheightChanged() {
    _canvas.style.height = "${stageheight  * stagescale}px";
    //_canvas.style.marginTop = "-${stagewidth * stagescale/2}px";
  }

  void stagescaleChanged() {
    _canvas.style.width = "${stagewidth * stagescale}px";
    //_canvas.style.marginLeft = "-${_canvas.offsetWidth/2}px";

    _canvas.style.height = "${stageheight  * stagescale}px";
    //_canvas.style.marginTop = "-${_canvas.offsetHeight/2}px";

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

  EventStreamProvider<CustomEvent> _elementSelectedEventP =
      new EventStreamProvider<CustomEvent>("elementselected");
  Stream<CustomEvent> get onElementSelected => _elementSelectedEventP.forTarget(
      this);
  void fireElementSelectedEvent(StageElement stage_el) {
    var event = new CustomEvent("elementselected", canBubble: false, cancelable:
        false, detail: stage_el);
    dispatchEvent(event);
  }


  EventStreamProvider<CustomEvent> _elementDeselectedEventP =
      new EventStreamProvider<CustomEvent>("elementdeselected");
  Stream<CustomEvent> get onElementDeselected =>
      _elementDeselectedEventP.forTarget(this);
  void fireElementDeselectedEvent(StageElement stage_el) {
    var event = new CustomEvent("elementdeselected", canBubble: false,
        cancelable: false, detail: stage_el);
    dispatchEvent(event);
  }

  EventStreamProvider<CustomEvent> _allElementsDeselectedEventP =
      new EventStreamProvider<CustomEvent>("allelementsdeselected");
  Stream<CustomEvent> get onAllElementDeselected =>
      _allElementsDeselectedEventP.forTarget(this);
  void fireAllElementsDeselectedEvent() {
    var event = new CustomEvent("allelementsdeselected", canBubble: false,
        cancelable: false, detail: null);
    dispatchEvent(event);
  }
}
