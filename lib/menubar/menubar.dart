part of dockable;

@CustomTag('menu-bar')
class Menubar extends PolymerElement {
  @published int size = 24;
  
  void sizeChanged() {
    this.style.maxHeight = "${this.size}px";
  }
  
  Menubar.created() : super.created() {
  }
  
  void enteredView() {
    super.enteredView();
    sizeChanged();
    /*for(Element _el in this.children) {
      if(_el is! MenuItem) {
        _el.remove();
      }
    }*/
  }
  
  bool addMenu(MenuItem arg_item) {
    bool ret = false;
    if(arg_item != null) {
      this.children.add(arg_item);
      ret = true;
    }
    return ret;
  }
  
  bool addMenuBefore(MenuItem before, MenuItem arg_item) {
    bool ret = false;
    if(arg_item != null) {
      if(before != null) {
        int index = this.children.indexOf(before);
        if(index != -1) {
          this.children.insert(index, arg_item);
          ret = true;
        }
      } else {
        this.children.add(arg_item);
        ret = true;
      }
    }
    return ret;
  }
  
  bool removeMenu(MenuItem arg_item) {
    return this.children.remove(arg_item);
  }
  
  num indexOf(MenuItem arg_item) {
    return this.children.indexOf(arg_item);
  }
}