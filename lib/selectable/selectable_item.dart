part of selectable;

abstract class SelectableItem {
  
  
  bool get isSelected;
  
  bool select();
  bool deselect();
  
  /* 
   * internal use only. should always call selected
   */
  bool _select();
  /*
   * called from _select to notify derived class that they have been selected
   */
  void selected();
  /*
   * internal use only. should always call deselected
   */
  bool _deselect();
  /*
   * called from _deselect to notify derived class that they have been deselected
   */
  void deselected();
  //void toggle();
  
  /*
   * This event fires when the item is selected
   */
  Stream get onSelect;  
  /*
   * This event fires when the item is deselected
   */
  Stream get onDeselect;
}

//TODO: seperate interface and implementation
class SelectableItemImpl implements SelectableItem {
  
  //events
  StreamController _selectionEventController = new StreamController.broadcast();
  Stream get onSelect => _selectionEventController.stream;
  
  StreamController _deselectionEventController = new StreamController.broadcast();
  Stream get onDeselect => _deselectionEventController.stream;
  
  bool _selected = false;
  bool get isSelected {
    return _selected;
  }
  
  bool select() {
    return false;
  }
  
  bool deselect() {
    return false;
  }
  
  bool _select() {
    bool ret = false;
    if(!_selected) {
      _selected = true;
      ret = true;
      selected();
      _selectionEventController.add(this);
    }
    return ret;
  }
  
  void selected() {
    
  }
  
  bool _deselect() {
    bool ret = false;
    if(_selected) {
      _selected = false;
      ret = true;
      deselected();
      _deselectionEventController.add(this);
    }
    return ret;
  }
  
  void deselected() {
    
  }
}