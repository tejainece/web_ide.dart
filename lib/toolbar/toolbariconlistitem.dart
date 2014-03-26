part of toolbar;

@CustomTag('toolbar-icon-list-item')
class ToolbarIconListItem extends ToolbarItem {
  ToolbarIconListItem.created() : super.created();

  /**
   * The URL of an image for the icon.
   */
  @published String src = '';

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void enteredView() {
    super.enteredView();
  }

  @override
  void leftView() {
    super.leftView();
  }

  void ready() {
    super.ready();
    _ic_bt = shadowRoot.querySelector("icon-list-button");
    assert(_ic_bt != null);

    //remove non-SubMenuItemBase elements
    for(HtmlElement el_t in children) {
      if(el_t is SubMenuItemBase) {
        el_t.remove();
        _ic_bt.addItem(el_t);
      } else {
        el_t.remove();
      }
    }
  }

  num _ICON_MARGIN_SIZE = 6.0;
  @observable num get ICON_MARGIN_SIZE => _ICON_MARGIN_SIZE;

  void set _size(int new_size) {
    this.style.width = "${new_size}px";
    _ICON_MARGIN_SIZE = ((6 * new_size)~/32);

    _ic_bt.height = new_size - (2 * ICON_MARGIN_SIZE);
    _ic_bt.height = new_size - (2 * ICON_MARGIN_SIZE);
  }

  IconListButton _ic_bt;
}