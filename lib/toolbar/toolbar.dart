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
 *
 * Testing:
 * 1) Vertical
 */

/**
 * tool-bar enables you to place an image centered in a button.
 *
 * Example:
 *
 *     <tool-bar></tool-bar>
 *
 * @class dockable-icon-button
 */

@CustomTag('tool-bar')
class ToolBar extends PolymerElement {
  ToolBar.created() : super.created();

  DivElement _content;

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void enteredView() {
    super.enteredView();
    sizeChanged();
    verticalChanged();
  }

  @override
  void ready() {
    super.ready();
    _content = shadowRoot.querySelector('.content');
    assert(_content != null);
    for(HtmlElement el_t in children) {
      if(el_t is ToolbarItem) {
        el_t.remove();
        addItem(el_t);
      } else {
        el_t.remove();
      }
    }
  }

  /**
   * Adds a toolbar item to the toolbar.
   */
  bool addItem(ToolbarItem arg_item) {
    bool ret = false;
    if(arg_item != null) {
      //TODO: should we find if it already belongs to another Toolbar
      arg_item.vertical = vertical;
      arg_item._set_size = size - 8;
      _content.children.add(arg_item);
      ret = true;
    }
    return ret;
  }

  bool insertItem(int index, ToolbarItem arg_item) {
    bool ret = false;
    if(arg_item != null) {
      arg_item.vertical = vertical;
      arg_item._set_size = size - 8;
      _content.children.insert(index, arg_item);
      ret = true;
    }
    return ret;
  }

  /**
   * Removes a toolbar item from the toolbar.
   */
  bool removeItem(ToolbarItem arg_item) {
    return _content.children.remove(arg_item);
  }

  ToolbarItem removeItemAt(int index) {
    return _content.children.removeAt(index);
  }

  List<ToolbarItem> get items => _content.children.toList(growable: false);

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
    for(HtmlElement item in _content.children) {
      if(item is ToolbarItem) {
        item._set_size = size - 8;
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
}