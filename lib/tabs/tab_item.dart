part of dockable;

class TabItem extends SelectableItemImpl {
  
  TabTitleItem _tab;
  PageItem _page;
  
  TabManager _manager;
  
  TabItem(Element arg_content, String arg_title) {
    _tab = new Element.tag('tab-title-item');
    _page = new Element.tag('page-item');
    _tab.setTitle(arg_title);
    _page.setContent(arg_content);
    
    _tab.onSelect.listen((tabItem) {
      select();
    });
  }
  
  Element _content;
  Element get content => _content;
  void set content(Element arg_content) {
    if(arg_content != null) {
      _content = arg_content;
    } else {
      _content = new DivElement();
    }
    _page.setContent(_content);
  }
  
  String _title = "";
  String get title => _title;
  void set title(String arg_title) {
    if(arg_title != null) {
      _title = arg_title;
    } else {
      _title = "";
    }
    _tab.setTitle(_title);
  }
  
  bool _hideCloseBtn = false;
  bool get hideCloseBtn => _hideCloseBtn;
  void set hideCloseBtn(bool arg_hideCloseBtn) {
    _hideCloseBtn = arg_hideCloseBtn;
    //TODO: hide it!!!
    //_tab.hasCloseBtn();
  }
  
  //TODO: implement 'should have close button' and 'should have minimize button'
  
  bool select() {
    if(_manager != null) {
      _manager.select(this);
    }
  }
  
  bool deselect() {
    if(_manager != null)
      _manager.deselect(this);
  }
  
  void selected() {
    _tab.select();
    _page.select();
  }
  
  void deselected() {
    _tab.deselect();
    _page.deselect();
  }
  
  /*StreamController _closeEventC = new StreamController.broadcast();
  Stream get onClose => _closeEventC.stream;*/
}