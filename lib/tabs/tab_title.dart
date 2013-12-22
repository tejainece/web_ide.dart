part of dockable.tabs;

@CustomTag('tab-title')
class TabTitle extends PolymerElement {
  DivElement _holder;
  
  Selectable _sel = new Selectable();

  TabTitle.created() : super.created() {
    _sel.multiSelect = false;
  }
  
  void enteredView() {
    _holder = this.shadowRoot.querySelector(".holder");
    if(_holder == null) {
      print("TabTitle: holder cannot be null!");
      assert(false);
    }
    //TODO: add all tabs in content
  }
  
  void addTab(TabTitleItem arg_item) {
    _sel.addItem(arg_item);
    _holder.children.add(arg_item);
    arg_item._parent = this;
    if(_sel.selected.length == 0 && _sel.items.length > 0) {
      //if this is the first tab, select it automatically
      _sel.select(_sel.items.first);
    }
  }
  
  void removeTab(TabTitleItem arg_item) {
    _sel.removeItem(arg_item);
    _holder.children.remove(arg_item);
    arg_item._parent = null;
  }
  
  num indexOf(TabTitleItem arg_item) {
    return _sel.indexOf(arg_item);
  }
  
  void select(TabTitleItem arg_item) {
    _sel.select(arg_item);
  }
  
  TabTitleItem get selected {
    if(_sel.selected.length == 1) {
      return _sel.selected.first;
    } else {
      return null;
    }
  }
}