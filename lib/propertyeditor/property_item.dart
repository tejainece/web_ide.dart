part of propertyeditor;

abstract class PropertyBase extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  PropertyBase.created() : super.created() {
  }

  @override
  void ready() {
    super.ready();
  }

  void set value(dynamic data);

  void startEditing();

  //events
  EventStreamProvider<CustomEvent> _updatedEventP = new EventStreamProvider<CustomEvent>("updated");
  Stream<CustomEvent> get onUpdated =>
      _updatedEventP.forTarget(this);
}

/**
 * PropertyItem.
 *
 * Example:
 *
 *     <property-item heading="Appearance" closed=true></property-item>
 *
 * @class PropertyItem
 */
@CustomTag('property-item')
class PropertyItem extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  PropertyItem.created() : super.created() {
  }

  DivElement _editorC;

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _editorC = shadowRoot.querySelector("#editorC");
    assert(_editorC != null);
  }

  void headingClicked() {
    if(_parent != null) {
      _parent.setDescription(this);
    }
  }

  PropertyCategory _parent;

  //content
  void setEditor(PropertyBase editor) {
    if(editor != null) {
      _editorC.children.clear();
      _editorC.children.add(editor);
    }
  }

  //properties
  @published String heading = "Unnamed";

  @published String description = "No description available!";
}
