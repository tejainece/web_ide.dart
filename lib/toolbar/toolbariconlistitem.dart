part of toolbar;

@CustomTag('toolbar-icon-list-item')
class ToolbarIconListItem extends ToolbarItem {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

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

    _ic_bt.setTriggerItem(this);

    //remove non-SubMenuItemBase elements
    for(HtmlElement el_t in children) {
      if(el_t is SubMenuItemBase) {
        el_t.remove();
        addItem(el_t);
      } else {
        el_t.remove();
      }
    }
  }

  bool addItem(SubMenuItemBase arg_item) {
    return _ic_bt.addItem(arg_item);
  }

  //TODO: implement insertAt, remove, removeAt

  //TODO: List<SubMenuItemBase> get items => _ic_bt.items;

  void set _set_size(int new_size) {
    this.style.width = "${new_size+9}px";
    this.style.height = "${new_size}px";

    _ic_bt.width = new_size;
    _ic_bt.height = new_size;
  }

  IconListButton _ic_bt;
}