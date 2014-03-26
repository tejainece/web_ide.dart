library toolbar;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

import '../iconbutton/icon_button.dart';
import "../menubar/menubar.dart";

part 'toolbaritem.dart';
part 'toolbariconitem.dart';
part 'toolbariconlistitem.dart';
part 'toolbarseparater.dart';

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

  DivElement _content;

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void enteredView() {
    super.enteredView();
    verticalChanged();
  }

  @override
  void ready() {
    super.ready();
    _content = shadowRoot.querySelector('.content');
    assert(_content != null);
    for(HtmlElement el_t in children) {
      if(el_t is ToolbarItem) {
        print(el_t is ToolbarItem);
        el_t.remove();
        addItem(el_t);
      } else {
        print(el_t is ToolbarSeparater);
      }
    }
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

    //change size of all items
    for(HtmlElement item in this.children) {
      if(item is ToolbarItem) {
        item._size = size;
      }
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
    bool ret = false;
    if(arg_item != null) {
      //TODO: should we find if it already belongs to another Toolbar and remove from it?
      arg_item.vertical = vertical;
      _content.children.add(arg_item);
      ret = true;
    }
    return ret;
  }

  //TODO: add item before

  /**
   * Removes a toolbar item from the toolbar.
   */
  bool removeItem(ToolbarItem arg_item) {
    return _content.children.remove(arg_item);
  }

  /**
   * Returns if the toolbar contains the provided toolbar item.
   */
  bool containsItem(ToolbarItem arg_item) {
     return this.children.contains(arg_item);
  }
}