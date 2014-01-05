library dockable.tabs;
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import '../selectable/selectable.dart';
import '../pages/page_manager.dart';

part 'tab_title_item.dart';
part 'tab_title.dart';
part 'tab_item.dart';

@CustomTag('tab-manager')
class TabManager extends PolymerElement with SelectionManager {

  //List<TabItem> _tabItems = new List<TabItem>();
  TabTitle __tabs;
  TabTitle get _tabs {
    if(__tabs == null) {
      __tabs = this.shadowRoot.querySelector("#header");
      assert(__tabs != null);
    }
    return __tabs;
  }
  PageManager __pages;
  PageManager get _pages {
    if(__pages == null) {
      __pages = this.shadowRoot.querySelector("#pages");
      assert(__pages != null);
    }
    return __pages;
  }
  
  TabManager.created() : super.created() {
    
  }
  
  void enteredView() {
    //TODO: add pages already present in dom
  }
  
  bool addItem(TabItem arg_tab) {
    bool ret = super.addItem(arg_tab);
    if(ret) {
      _tabs.addItem(arg_tab._tab);
      _pages.addItem(arg_tab._page);
      arg_tab._manager = this;
    }
    return ret;
  }
  
  bool removeItem(TabItem arg_tab) {
    bool ret = super.removeItem(arg_tab);
    if(ret) {
      _tabs.removeItem(arg_tab._tab);
      _pages.removeItem(arg_tab._page);
      arg_tab._manager = null;
    }
    return ret;
  }
  
  bool deselect(TabItem arg_tab) {
    return false;
  }
  
  TabItem get selectedItem => super.selectedItem;
}