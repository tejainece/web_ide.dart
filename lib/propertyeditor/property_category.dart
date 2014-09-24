part of propertyeditor;

/*
 * TODO:
 * 1) implement sorted
 * 2) restrict access to children
 */

/**
 * PropertyCategory.
 *
 * Example:
 *
 *     <property-category heading="Appearance"></property-category>
 *
 * @class dockable-icon
 */
@CustomTag('property-category')
class PropertyCategory extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  PropertyCategory.created() : super.created() {
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
  }

  DivElement _holderDiv;
  DivElement get _holder {
    if(_holderDiv == null) {
      _holderDiv = shadowRoot.querySelector("#holder");
      assert(_holderDiv != null);
    }
    return _holderDiv;
  }

  PropertyEditor _parent;

  //items
  /*List<PropertyItem> get children {
    return _holder.children.toList(growable: false);
  }*/

  void addItem(PropertyItem item) {
    if(item != null && item._parent == null) {
      _holder.children.add(item);
      item._parent = this;
    }
  }

  void removeItem(PropertyItem item) {
    if(item._parent == this) {
      _holder.children.remove(item);
      item._parent = null;
    }
  }

  //properties
  @published bool closed = false;

  @published String heading = "Unnamed";

  @published bool sorted = false;

  void setDescription(PropertyItem item) {
    if(_parent != null) {
      _parent._setDescription(item);
    }
  }
}
