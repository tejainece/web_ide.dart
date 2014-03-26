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
    _ic_bt.onChanged.listen((_) {
      if(_ic_bt.checked) {
        this.classes.add("active");
      } else {
        this.classes.remove("active");
      }
    });
  }

  num _ICON_MARGIN_SIZE = 6.0;
  @observable num get ICON_MARGIN_SIZE => _ICON_MARGIN_SIZE;

  void set _size(int new_size) {
    this.style.width = "${new_size}px";
    _ICON_MARGIN_SIZE = ((6 * new_size)~/32);

    _ic_bt.height = new_size - (2 * ICON_MARGIN_SIZE);
    _ic_bt.height = new_size - (2 * ICON_MARGIN_SIZE);
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