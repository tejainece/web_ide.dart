part of toolbar;

@CustomTag('toolbar-item')
class ToolbarItem extends PolymerElement {
  ToolbarItem.created() : super.created();

  void set _size(int new_size) {
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