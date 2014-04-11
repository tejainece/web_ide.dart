library list;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

import 'dart:mirrors';

part 'list_item.dart';

/*
 * TODO:
 * Implement static html addition of list-items
 */

/**
 * list-box is an element that displays list of details or options.
 *
 * Example:
 *
 *     <list-box multiselect="false"></list-box>
 *
 * @class list-box
 */
@CustomTag('list-box')
class ListBox extends PolymerElement {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  ListBox.created(): super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Dockable.ListBox');

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
  }

  @override
  void enteredView() {
    super.enteredView();
    List<HtmlElement> initItems = new List<HtmlElement>();
    /*for (HtmlElement child in this.children) {
      if (true/*child is ListItem*/) { //TODO: old add if child is ListItem
        initItems.add(child);
      }
    }

    this.children.clear();

    for (HtmlElement child in initItems) {
      child.remove();
      addItem(child as ListItem);
    }*/
  }

  DivElement _divholder;
  DivElement get _holder {
    if (_divholder == null) {
      _divholder = shadowRoot.querySelector(".holder");
      assert(_divholder != null);
    }
    return _divholder;
  }

  bool addItem(ListItem item) {
    bool ret = false;
    if (item != null && !containsItem(item)) {
      _holder.children.add(item);
      item._added(this);
      ret = true;
    }
    return ret;
  }

  bool removeItem(ListItem item) {
    bool ret = false;
    /*
     * Remove item only if
     * 1) item is not null
     * 2) item is member of this listbox
     */
    if(item != null && item._listbox == this) {
      ret = _holder.children.remove(item);
    }
    if(ret) {
      item._deselect();
      item._removed();
    }
    return ret;
  }

  void removeAllItems() {
    List<Element> listEl = _holder.children.toList(growable: false);

    for(ListItem el in listEl) {
      removeItem(el);
    }
  }

  bool containsItem(ListItem item) {
    return _holder.contains(item);
  }

  /* selection */
  List<ListItem> _selectedItems = new List<ListItem>();
  void select(ListItem item) {
    /*
     * Select the item only if
     * 1) Not null
     * 2) Is member of the list
     * 3) Is not already selected
     */
    if(item != null && _holder.contains(item) && !_selectedItems.contains(item)) {
      if(multiselect) {
        _selectedItems.add(item);
        item._select();
      } else {
        deselectAll();
        _selectedItems.add(item);
        item._select();
      }
    }
  }

  void deselect(ListItem item) {
    if(_selectedItems.contains(item)) {
      _selectedItems.remove(item);
      item._deselect();
    }
  }

  void deselectAll() {
    for(ListItem item in _selectedItems) {
      item._deselect();
    }
    _selectedItems.clear();
  }

  List<ListItem> getSelected() => _selectedItems;

  /* Properties */
  @published
  bool multiselect = false;

  @published
  int itemheight = 20;

  void multiselectChanged() {
    if(multiselect == false && _selectedItems.length > 1) {
      /* retain the latest selected item */
      ListItem item = _selectedItems.removeLast();
      deselectAll();
      _selectedItems.add(item);
    }
  }

  void itemheightChanged() {
    for(ListItem item in _holder.children) {
      item.style.height = "${itemheight}px";
    }
  }
}
