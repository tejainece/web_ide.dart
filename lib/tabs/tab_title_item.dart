part of dockable.tabs;

@CustomTag('tab-title-item')
class TabTitleItem extends PolymerElement with SelectableItem {
  @published String icon = "";
  @published String title = "";
  @published bool hasCloseBtn = true;
  
  TabTitle _parent = null;
  
  DivElement _holderDiv;
  DivElement _iconDiv;
  DivElement _titleDiv;
  DivElement _closeBtnDiv;

  TabTitleItem.created() : super.created() {
    
  }
  
  void enteredView() {
    _holderDiv = this.shadowRoot.querySelector(".holder");
    if(_holderDiv == null) {
      print("TabTitleItem: holder cannot be null!");
      assert(false);
    } else {
      _iconDiv = _holderDiv.querySelector(".icon");
      if(_iconDiv == null) {
        print("TabTitleItem: iconDiv cannot be null!");
        assert(false);
      }
      _titleDiv = _holderDiv.querySelector(".title");
      if(_titleDiv == null) {
        print("TabTitleItem: titleDiv cannot be null!");
        assert(false);
      }
      _closeBtnDiv = _holderDiv.querySelector(".closebtn");
      if(_closeBtnDiv == null) {
        print("TabTitleItem: closeBtnDiv cannot be null!");
        assert(false);
      }
    }
    //TODO: add all tabs in content
    
    _holderDiv.onClick.listen((e) {
      if(_parent != null) {
        _parent.select(this);
      }
    });
  }
  
  void setTitle(String arg_content) {
    _titleDiv.text = arg_content;
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