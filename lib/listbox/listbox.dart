library list;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import 'dart:mirrors';

part 'listbox_item.dart';

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
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
    _holder = shadowRoot.querySelector(".holder");
    assert(_holder != null);

    //remove non ListboxItem
    List<HtmlElement> initItems = new List<HtmlElement>();
    for (HtmlElement child in super.children) {
      if (child is ListboxItem) {
        child.remove();
        addItem(child);
      } else {
        child.remove();
      }
    }
  }

  @override
  void enteredView() {
    super.enteredView();
  }

  DivElement _holder;

  bool addItem(ListboxItem item) {
    bool ret = false;
    if (item != null && !containsItem(item)) {
      _holder.children.add(item);
      item._added(this);
      ret = true;
    }
    return ret;
  }

  bool removeItem(ListboxItem item) {
    bool ret = false;
    /*
     * Remove item only if
     * 1) item is not null
     * 2) item is member of this listbox
     */
    if (item != null && item._listbox == this) {
      ret = _holder.children.remove(item);
    }
    if (ret) {
      item._deselect();
      item._removed();
    }
    return ret;
  }

  void removeAllItems() {
    List<Element> listEl = _holder.children.toList(growable: false);

    for (ListboxItem el in listEl) {
      removeItem(el);
    }
  }

  bool containsItem(ListboxItem item) {
    return _holder.contains(item);
  }

  /* selection */
  List<ListboxItem> _selectedItems = new List<ListboxItem>();
  void select(ListboxItem item) {
    if (!selectable) {
      return;
    }
    /*
     * Select the item only if
     * 1) Not null
     * 2) Is member of the list
     * 3) Is not already selected
     */
    if (item != null && _holder.contains(item) && !_selectedItems.contains(item
        )) {
      if (multiselect) {
        _selectedItems.add(item);
        item._select();
      } else {
        deselectAll();
        _selectedItems.add(item);
        item._select();
      }
    }
  }

  void deselect(ListboxItem item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
      item._deselect();
    }
  }

  void deselectAll() {
    for (ListboxItem item in _selectedItems) {
      item._deselect();
    }
    _selectedItems.clear();
  }

  List<ListboxItem> getSelected() => _selectedItems;

  /* Properties */
  @published
  bool selectable = true;

  @published
  bool multiselect = false;

  @published
  int itemheight = 20;

  void selectableChanged() {
    if (_selectedItems.length > 0) {
      deselectAll();
    }
  }

  void multiselectChanged() {
    if (multiselect == false && _selectedItems.length > 1) {
      /* retain the latest selected item */
      ListboxItem item = _selectedItems.removeLast();
      deselectAll();
      _selectedItems.add(item);
    }
  }

  void itemheightChanged() {
    for (ListboxItem item in _holder.children) {
      item.style.height = "${itemheight}px";
    }
  }
}
