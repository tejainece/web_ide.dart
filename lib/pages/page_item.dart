part of dockable.pages;

@CustomTag('page-item')
class PageItem extends PolymerElement with SelectableItemImpl {
  PageManager _parent = null;
  PageManager get parent => _parent;

  DivElement __holder;
  DivElement get _holder {
    if(__holder == null) {
      __holder = shadowRoot.querySelector('#holder');
      assert(__holder != null);
    }
    return __holder;
  }
  
  PageItem.created() : super.created() {
    
  }
  
  void enteredView() {
    //TODO: add all tabs in content
  }
  
  void setContent(Element arg_content) {
    if(arg_content != null) {
      _holder.children.clear();
      _holder.children.add(arg_content);
    }
  }
  
  bool select() {
    return _parent.select(this);
  }
  
  bool deselect() {
    return false;
  }
  
  void selected() {
    this.classes.add('active');
  }
  
  void deselected() {
    this.classes.remove('active');
  }
}