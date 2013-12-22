part of dockable.tabs;

//TODO: implement selectable_item interface - select, deselect, toggle, onSelect, onDeselect 
class TabItem {
  
  TabTitleItem _tab;
  PageItem _page;
  
  TabManager _manager;
  
  TabItem(Element arg_content, String arg_title) {
    _tab = new Element.tag('tab-title-item');
    _page = new Element.tag('page-item');
    
    _tab.onSelect.listen((TabTitleItem tabItem) {
      if(_manager != null) {
        _manager._pages.select(_page);
      }
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
}