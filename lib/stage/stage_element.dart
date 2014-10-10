part of stage;

/**
 * stage-element is a stage used to create GUI interfaces like XCode Storyboard.
 *
 *     <stage-element width="720" height="480"></dockable-icon>
 *
 * @class dock-stage
 */
@CustomTag('stage-element')
class StageElement extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  StageElement.created() : super.created() {
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
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
      if (_stage != null && isSelected/* && event.button == 0*/) {
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

  /* Selection */
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
    this.classes.add("selected");

    //TODO: send valid detail
    var event = new CustomEvent("selected", canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }

  void _deselected() {
    this.classes.remove("selected");

    //TODO: send valid detail
    var event = new CustomEvent("deselected", canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
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
  int left = 0;

  @published
  int top = 0;

  @published
  int width = 0;

  @published
  int height = 0;

  @published
  bool resizable = true;

  @published
  bool movable = true;

  @published
  bool selectable = true;

  @published
  String text = "";

  @observable
  int get scaledleft {
    if(_stage != null) {
      return left * _stage.stagescale;
    } else {
      return 0;
    }
  }

  @observable
  int get scaledtop  {
    if(_stage != null) {
      return top * _stage.stagescale;
    } else {
      return 0;
    }
  }

  @observable
  int get scaledwidth  {
    if(_stage != null) {
      return width * _stage.stagescale;
    } else {
      return 0;
    }
  }

  @observable
  int get scaledheight  {
    if(_stage != null) {
      return height * _stage.stagescale;
    } else {
      return 0;
    }
  }

  void leftChanged() {
    if (_stage != null) {
      notifyPropertyChange(#scaledleft, 0, scaledleft);
      this.style.left = "${scaledleft}px";

      _stage._showHideAnchors();

      var event = new CustomEvent("poschanged", canBubble: false, cancelable: false, detail: null);
      dispatchEvent(event);
    }
  }

  void topChanged() {
    if (_stage != null) {
      notifyPropertyChange(#scaledtop, 0, scaledtop);
      this.style.top = "${scaledtop}px";

      _stage._showHideAnchors();

      var event = new CustomEvent("poschanged", canBubble: false, cancelable: false, detail: null);
      dispatchEvent(event);
    }
  }

  void widthChanged() {
    if (_stage != null) {
      notifyPropertyChange(#scaledwidth, 0, scaledwidth);
      this.style.width = "${scaledwidth}px";

      _stage._showHideAnchors();

      var event = new CustomEvent("sizechanged", canBubble: false, cancelable: false, detail: null);
      dispatchEvent(event);
    }
  }

  void heightChanged() {
    if (_stage != null) {
      notifyPropertyChange(#scaledheight, 0, scaledheight);
      this.style.height = "${scaledheight}px";

      _stage._showHideAnchors();

      var event = new CustomEvent("sizechanged", canBubble: false, cancelable: false, detail: null);
      dispatchEvent(event);
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

  void textChanged() {

  }

  EventStreamProvider<CustomEvent> _sizeChangedEventP = new EventStreamProvider<CustomEvent>("sizechanged");
  Stream<CustomEvent> get onSizeChanged => _sizeChangedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _posChangedEventP = new EventStreamProvider<CustomEvent>("poschanged");
  Stream<CustomEvent> get onPosChanged => _posChangedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _selectedEventP = new EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _selectedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _deselectedEventP = new EventStreamProvider<CustomEvent>("deselected");
  Stream<CustomEvent> get onDeselected => _deselectedEventP.forTarget(this);
}
