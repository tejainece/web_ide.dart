part of dockable.stage;

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
  num scale = 1;

  @published
  bool resizable = true;

  @published
  bool movable = true;

  @published
  bool selectable = true;

  @published
  String text = "";
  
  @published
  int fontsize = 16;
  
  @observable
  int get scaledFontsize => (fontsize * scale).toInt();

  void selectableChanged() {
    if (selectable == false) {
      //TODO: deselect();
    }
  }
  
  void leftChanged() {
    this.fire("moved", detail: {"left": left, "top": top,});
  }
  
  void topChanged() {
    this.fire("moved", detail: {"left": left, "top": top,});
  }
  
  void widthChanged() {
    this.fire("resized", detail: {"width": width, "height": height,});
  }
  
  void heightChanged() {
    this.fire("resized", detail: {"width": width, "height": height,});
  }
  
  void scaleChanged() {
    notifyPropertyChange(#scaledFontsize, null, scaledFontsize);
    print(scaledFontsize);
  }
  
  void fontsizeChanged() {
    notifyPropertyChange(#scaledFontsize, null, scaledFontsize);
  }
  
  EventStreamProvider<CustomEvent> _movedEventP = new EventStreamProvider<CustomEvent>("moved");
  Stream<CustomEvent> get onMoved => _movedEventP.forTarget(this);
  
  EventStreamProvider<CustomEvent> _resizedEventP = new EventStreamProvider<CustomEvent>("resized");
  Stream<CustomEvent> get onResized => _resizedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _selectedEventP = new EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected => _selectedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _deselectedEventP = new EventStreamProvider<CustomEvent>("deselected");
  Stream<CustomEvent> get onDeselected => _deselectedEventP.forTarget(this);
}
