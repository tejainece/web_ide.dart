part of toolbar;

@CustomTag('toolbar-icon-item')
class ToolbarIconItem extends ToolbarItem {
  ToolbarIconItem.created() : super.created();

  /**
   * The URL of an image for the icon.
   */
  @published String src = '';

  /**
   * Sets if the icon button is togglable
   */
  @published bool togglable = false;

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  void ready() {
    super.ready();
    _ic_bt.onSelected.listen((_) {
      this.classes.add("active");
    });
    _ic_bt.onDeselected.listen((_) {
      this.classes.remove("active");
    });
  }

  void set _size(int new_size) {
    super._size = new_size;
    _ic_bt.size = new_size - 12;
  }

  IconButton _ic_bt_el;
  IconButton get _ic_bt {
    if(_ic_bt_el == null) {
      _ic_bt_el = shadowRoot.querySelector("icon-button");
      assert(_ic_bt_el != null);
    }
    return _ic_bt_el;
  }
}