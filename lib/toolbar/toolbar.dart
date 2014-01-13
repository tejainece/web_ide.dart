library dockable.toolbar;

import 'dart:html';

import 'package:polymer/polymer.dart';
import '../iconbutton/dockable_icon_button.dart';

part 'toolbariconitem.dart';
part 'toolbarseparater.dart';

class ToolbarItem extends PolymerElement {
  ToolbarItem.created() : super.created();
  
  /*
   * Size of the element.
   */
  @published int size = 24;
  
  void sizeChanged() {
    if(vertical) {
      this.style.height = "${this.size}px";
    } else {
      this.style.width = "${this.size}px";
    }
  }
  
  /*
   * Is the item displayed vertically or horizontally?
   * This is complement to item's parent's orientation.
   */
  @published bool vertical = false;
  
  void verticalChanged() {
    print('icon item: verticalChanged');
    if(vertical) {
      this.classes.add('vertical');
    } else {
      this.classes.remove('vertical');
    }
    sizeChanged();
  }
}

/*
 * TODO:
 * Development:
 * 1) Improve looks
 * 
 * Testing:
 * 1) Vertical
 */

/**
 * dockable-toolbar enables you to place an image centered in a button.
 *
 * Example:
 *
 *     <dockable-toolbar></dockable-toolbar>
 *
 * @class dockable-icon-button
 */
@CustomTag('dockable-toolbar')
class DockableToolbar extends PolymerElement {
  DockableToolbar.created() : super.created();
  
  HtmlElement __content;
  HtmlElement get _content {
    if(__content == null) {
      __content = shadowRoot.querySelector('content');
      assert(__content != null);
    }
    return __content;
  }
  
  @override 
  void polymerCreated() {
    super.polymerCreated();
  }
  
  @override
  void enteredView() {
    super.enteredView();
    verticalChanged();
  }
  
  /**
   * Size of toolbar.
   */
  @published int size = 24;
  
  void sizeChanged() {
    if(vertical) {
      this.style.width = "${this.size}px";
    } else {
      this.style.height = "${this.size}px";
    }
  }
  
  /**
   * Direction of the toolbar.
   */
  @published bool vertical = false;
  
  void verticalChanged() {    
    if(vertical) {
      this.classes.add('vertical');
    } else {
      this.classes.remove('vertical');
    }
    sizeChanged();
    print('content length: ${this.children.length}');
    for(HtmlElement _item in this.children) {
      if(_item is ToolbarItem) {
        _item.vertical = vertical;
      } else {
        _item.remove();
      }
    }
  }
  
  /**
   * Adds a toolbar item to the toolbar.
   */
  bool addItem(ToolbarItem arg_item) {
    if(arg_item != null) {
      //TODO: should we find if it already belongs to another Toolbar and remove from it?
      arg_item.vertical = vertical;
      this.children.add(arg_item);
    }
  }
  
  //TODO: add item before
  
  /**
   * Removes a toolbar item from the toolbar.
   */
  bool removeItem(ToolbarItem arg_item) {
    return this.children.remove(arg_item);
  }
  
  /**
   * Returns if the toolbar contains the provided toolbar item.
   */
  bool containsItem(ToolbarItem arg_item) {
     return this.children.contains(arg_item);
  }
}