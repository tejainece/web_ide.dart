library dockable.tabs;
import 'package:polymer/polymer.dart';
import 'dart:html';

import '../selectable/selectable.dart';
import '../pages/page_manager.dart';

part 'tab_title_item.dart';
part 'tab_title.dart';
part 'tab_item.dart';

@CustomTag('tab-manager')
class TabManager extends PolymerElement {

  List<TabItem> _tabItems = new List<TabItem>();
  TabTitle _tabs;
  PageManager _pages;
  
  TabManager.created() : super.created() {
    
  }
  
  void enteredView() {
    _tabs = this.shadowRoot.querySelector("#header");
    if(_tabs == null) {
      print("TabManager: tabs cannot be null!");
      assert(false);
    }
    
    _pages = this.shadowRoot.querySelector("#pages");
    if(_pages == null) {
      print("TabManager: pages cannot be null!");
      assert(false);
    }
    //TODO: add pages already present in dom
  }
  
  bool addTab(TabItem arg_tab) {
    //TODO: make sure that we don't add same content twice
    bool ret = false;
    if(!_tabItems.contains(arg_tab)) {
      _tabItems.add(arg_tab);
      _tabs.addTab(arg_tab._tab);
      _pages.addPage(arg_tab._page);
      arg_tab._manager = this;
      ret = true;
    }
    return ret;
  }
  
  bool removeTab(TabItem arg_tab) {
    bool ret = false;
    if(_tabItems.contains(arg_tab)) {
      _tabItems.remove(arg_tab);
      _tabs.removeTab(arg_tab._tab);
      _pages.removePage(arg_tab._page);
      arg_tab._manager = null;
      ret = true;
    }
    return ret;
  }
  
  void getSelectedTab() {
    //TODO: implement
  }
  
  void selectedIndex() {
    //TODO: implement
  }
}