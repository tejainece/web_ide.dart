part of dockable.tabs;

@CustomTag('tab-title')
class TabTitle extends PolymerElement {
  DivElement __holder;
  DivElement get _holder {
    if(__holder == null) {
      __holder = this.shadowRoot.querySelector(".holder");
      assert(__holder != null);
    }
    return __holder;
  }
  
  SelectionManager _sel = new SelectionManager();

  TabTitle.created() : super.created() {
  }
  
  void enteredView() {
    //TODO: add all tabs in content
  }
  
  bool addItem(TabTitleItem arg_item) {
    _sel.addItem(arg_item);
    _holder.children.add(arg_item);
    arg_item._parent = this;
    if(_sel.selectedItem == null && _sel.items.length > 0) {
      //if this is the first tab, select it automatically
      _sel.select(_sel.items.first);
    }
  }
  
  bool removeItem(TabTitleItem arg_item) {
    _sel.removeItem(arg_item);
    _holder.children.remove(arg_item);
    arg_item._parent = null;
  }
  
  num indexOf(TabTitleItem arg_item) {
    return _sel.indexOf(arg_item);
  }
  
  bool select(TabTitleItem arg_item) {
    return _sel.select(arg_item);
  }
  
  bool deselect(TabTitleItem arg_item) {
    return false;
  }
  
  TabTitleItem get selectedItem => _sel.selectedItem;
}