part of dockable.pages;

//TODO: implement events - selected, deselcted, etc

@CustomTag('page-item')
class PageItem extends PolymerElement with SelectableItem {
  PageManager _parent = null;
  PageManager get parent => _parent;

  PageItem.created() : super.created() {
    
  }
  
  void enteredView() {
    //TODO: add all tabs in content
  }
  
  void setContent(Element arg_content) {
    if(arg_content != null) {
      shadowRoot.children.clear();
      shadowRoot.children.add(arg_content);
    }
  }
  
  bool select() {
    bool ret = super.select();;
    if(ret) {
      this.classes.add('active');
    }
    return ret;
  }
  
  bool deselect() {
    bool ret = super.deselect();
    if(ret) {
      this.classes.remove('active');
    }
  }
}