part of toolbar;

@CustomTag('toolbar-icon-item')
class ToolbarIconItem extends ToolbarItem {
  ToolbarIconItem.created() : super.created();

  /**
   * The URL of an image for the icon.
   */
  @published String src = '';
  
  @PublishedProperty(reflect: true) String icon = '';

  /**
   * Sets if the icon button is togglable
   */
  @published bool togglable = false;
  @published bool checked = false;

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

  int _size = 16;
  @observable int get size => _size;

  void set _set_size(int new_size) {
    _size = new_size;
    notifyPropertyChange(#size, 0, _size);
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