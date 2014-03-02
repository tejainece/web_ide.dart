part of stage;

/*
 * TODO:
 * Implement resize
 * Implement select and deselect events
 */

/**
 * stage-element is a stage used to create GUI interfaces like XCode Storyboard.
 *
 *     <stage-element width="720" height="480"></dockable-icon>
 *
 * @class dock-stage
 */
@CustomTag('stage-element')
class StageElement extends PolymerElement {
  StageElement.created(): super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Dockable.ColorPicker');

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
  }

  @override
  void leftView() {

  }

  /*
   * Should be only called from parent when the element is added to it
   */
  void _added(DockStage stage) {
    _stage = stage;
    _click = onClick.listen((MouseEvent event) {
      if (_stage != null) {
        _stage._stageClicked(event);
        event.stopPropagation();
      }
    });

    _mouseDown = onMouseDown.listen((MouseEvent event) {
      if(_stage != null && isSelected) {
        _savedPosBeforeMove = new Point(offsetLeft, offsetTop);
        _stage._startMove(event);
      }
    });
  }

  /*
     * Should be only called from parent when the element is removed from it
     */
  void _removed() {
    if (_click != null) {
      _click.cancel();
      _click = null;
    }
    if (_mouseDown != null) {
      _mouseDown.cancel();
      _mouseDown = null;
    }
    if (_stage != null) {
      _stage = null;
    }
  }

  StreamSubscription _click;
  StreamSubscription _mouseDown;

  /*
   * Selects the element
   */
  select(bool multi) {
    if (_stage != null) {
      _stage.selectElement(this);
    }
  }

  /*
   * Deselects the element
   */
  deselect() {
    if (_stage != null) {
      _stage.deselectElement(this);
    }
  }

  void _selected() {
    //TODO: show anchors
    this.classes.add("selected");
  }

  void _deselected() {
    this.classes.remove("selected");
  }

  /*
   * Parent stage
   */
  DockStage _stage;

  /*
   * Is the element selected?
   */
  bool get isSelected {
    if (_stage != null) {
      return _stage._selected.contains(this);
    } else {
      return false;
    }
  }

  /* Move */
  Point _savedPosBeforeMove;

  void _moved() {

  }

  /*
   * Properties
   */
  @published
  num left = 0;

  @published
  num top = 0;

  @published
  num width = 0;

  @published
  num height = 0;

  @published
  bool resizable = true;

  @published
  bool movable = true;

  @published
  bool selectable = true;

  void leftChanged() {
    this.style.left = "${left * _stage.stagescale}px";
  }

  void topChanged() {
    this.style.top = "${top * _stage.stagescale}px";
  }

  void widthChanged() {
    if(_stage != null) {
      this.style.width = "${width * _stage.stagescale}px";
    }
  }

  void heightChanged() {
    if(_stage != null) {
      this.style.height = "${height * _stage.stagescale}px";
    }
  }

  void resizableChanged() {

  }

  void movableChanged() {

  }

  void selectableChanged() {
    if (selectable == false) {
      deselect();
    }
  }
}
