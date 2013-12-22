library dockable.pages;
import 'package:polymer/polymer.dart';
import 'dart:html';

import '../selectable/selectable.dart';

part 'page_item.dart';

@CustomTag('page-manager')
class PageManager extends PolymerElement {
  
  Selectable _sel = new Selectable();

  PageManager.created() : super.created() {
    _sel.multiSelect = false;
  }
  
  void enteredView() {
    //TODO: add all tabs in content
  }
  
  bool addPage(PageItem arg_item) {
    bool ret = _sel.addItem(arg_item);
    if(ret) {
      shadowRoot.children.add(arg_item);
      arg_item._parent = this;
    }
    //TODO: maybe move the 'select first if nothing is selected yet' to the tab-manager? 
    if(_sel.selected.length == 0 && _sel.items.length > 0) {
      //if this is the first tab, select it automatically
      _sel.select(_sel.items.first);
    }
    return ret;
  }
  
  bool removePage(PageItem arg_item) {
    bool ret = _sel.removeItem(arg_item);
    if(ret) {
      shadowRoot.children.remove(arg_item);
      arg_item._parent = null;
    }
    return ret;
  }
  
  num indexOf(PageItem arg_item) {
    return _sel.indexOf(arg_item);
  }
  
  void select(PageItem arg_item) {
    _sel.select(arg_item);
  }
  
  PageItem get selected {
    if(_sel.selected.length == 1) {
      return _sel.selected.first;
    } else {
      return null;
    }
  }
}