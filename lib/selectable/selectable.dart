library selectable;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

part 'multi_selectable.dart';
part 'selectable_item.dart';


abstract class Selectable {
  List<SelectableItem> get items;
  bool addItem(SelectableItem arg_item);
  bool removeItem(SelectableItem arg_item);

  //TODO: implement
  //bool insertAfter(SelectableItem arg_item);
  //bool insertBefore(SelectableItem arg_item);

  //num indexOf(SelectableItem arg_item);

  SelectableItem get selectedItem;
  bool isSelected(SelectableItem arg_item);

  bool select(SelectableItem arg_item);
  bool deselect(SelectableItem arg_item);
}

class SelectionManager implements Selectable {
  List<SelectableItem> _items = new List<SelectableItem>();
  List<SelectableItem> get items {
    //TODO: can we somehow return unmutable or const list?
    return _items;
  }

  bool addItem(SelectableItem arg_item) {
    bool ret = false;
    if(!_items.contains(arg_item)) {
      _items.add(arg_item);
      ret = true;
    }
    return ret;
  }

  bool removeItem(SelectableItem arg_item) {
    bool ret = false;
    if(_items.contains(arg_item)) {
      //deselect before removing
      deselect(arg_item);
      _items.remove(arg_item);
      ret = true;
    }
    return ret;
  }

  num indexOf(SelectableItem arg_item) {
    return _items.indexOf(arg_item);
  }

  SelectableItem _selected;

  SelectableItem get selectedItem => _selected;

  bool isSelected(SelectableItem arg_item) {
    return _selected == arg_item;
  }

  bool select(SelectableItem arg_item) {
    bool ret = false;
    if(_items.contains(arg_item) && _selected != arg_item) {
      if(_selected != null) {
        _selected._deselect();
        _selected = null;
      }
      arg_item._select();
      _selected = arg_item;
      ret = true;
    }
    return ret;
  }

  bool deselect(SelectableItem arg_item) {
    bool ret = false;
    if(_items.contains(arg_item) && _selected == arg_item) {
      arg_item._deselect();
      _selected = null;
      ret = true;
    }
    return ret;
  }

  /*void toggle(SelectableItem arg_item) {
    if(_items.contains(arg_item)) {
      if(_selected == arg_item) {
        deselect(arg_item);
      } else {
        select(arg_item);
      }
    }
  }*/
}