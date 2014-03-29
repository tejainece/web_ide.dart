part of toolbar;

@CustomTag('toolbar-item')
class ToolbarItem extends PolymerElement {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  ToolbarItem.created() : super.created();

  void set _set_size(int new_size) {
  }

  /*
   * Is the item displayed vertically or horizontally?
   * This is complement to item's parent's orientation.
   */
  @published bool vertical = false;

  void verticalChanged() {
    if(vertical) {
      this.classes.add('vertical');
    } else {
      this.classes.remove('vertical');
    }
  }
}