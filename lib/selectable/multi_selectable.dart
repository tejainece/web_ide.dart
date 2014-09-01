part of selectable;

abstract class MultiSelectable extends Selectable {
  void set multiSelect(bool arg_multi);
  bool get multiSelect;
  List<SelectableItem> get selectedItems;
}

class MultiSelectionManager implements MultiSelectable {
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
  
  //TODO: implement
  /*void insertAfter(SelectableItem arg_item) {
    
  }
  
  void insertBefore(SelectableItem arg_item) {
    
  }*/
  
  List<SelectableItem> _selected = new List<SelectableItem>();
  SelectableItem get selectedItem {
    if(_selected.isEmpty) {
      return null;
    } else {
      return _selected.first;
    }
  }
  List<SelectableItem> get selectedItems {
    //TODO: can we somehow return unmutable or const list?
    return _selected;
  }
  
  bool isSelected(SelectableItem arg_item) {
    return _selected.contains(arg_item);
  }
  
  bool select(SelectableItem arg_item) {
    bool ret = false;
    if(_items.contains(arg_item) && !_selected.contains(arg_item)) {
      if(_isMultiSelect == false) {
        switch(_selected.length) {
          case 1:
            _selected.removeLast()._deselect();
            break;
          case 0:
            break;
          default:
            print("Selectable has more than one selection in single selection mode");
            assert(false);
        }
        arg_item._select();
        _selected.add(arg_item);
      } else {
        arg_item._select();
        _selected.add(arg_item);
      }
      ret = true;
    }
    return ret;
  }
  
  bool deselect(SelectableItem arg_item) {
    bool ret = false;
    if(_items.contains(arg_item) && _selected.contains(arg_item)) {
      arg_item._deselect();
      _selected.remove(arg_item);
      ret = true;
    }
    return ret;
  }
  
  void toggle(SelectableItem arg_item) {
    if(_items.contains(arg_item)) {
      if(_selected.contains(arg_item)) {
        deselect(arg_item);
      } else {
        select(arg_item);
      }
    }
  }
  
  bool _isMultiSelect = false;
  void set multiSelect(bool arg_multi) {
    if(_isMultiSelect != arg_multi) {
      if(_isMultiSelect == false && _selected.length > 1) {
        //deselect if there are multiple selections and keep the
        //first selected item
        SelectableItem firstSel = _selected.removeAt(0);
        for(SelectableItem selitem in _selected) {
          selitem._deselect();
        }
        _selected.clear();
        _selected.add(firstSel);
      }
      _isMultiSelect = arg_multi;
    }
  } 
  
 bool get multiSelect => _isMultiSelect;
}