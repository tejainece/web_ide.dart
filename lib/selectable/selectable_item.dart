part of selectable;

//TODO: seperate interface and implementation
class SelectableItem {
  
  bool _selected = false;
  bool get isSelected {
    return _selected;
  }
  
  bool select() {
    bool ret = false;
    if(!_selected) {
      _selected = true;
      ret = true;
      _selectionEventController.add(this);
    }
    return ret;
  }
  
  bool deselect() {
    bool ret = false;
    if(_selected) {
      _selected = false;
      ret = true;
      _deselectionEventController.add(this);
    }
    return ret;
  }
  
  void toggle() {
    if(_selected) {
      deselect();
    } else {
      select();
    }
  }
  
  //events
  StreamController _selectionEventController = new StreamController.broadcast();
  Stream get onSelect => _selectionEventController.stream;
  
  StreamController _deselectionEventController = new StreamController.broadcast();
  Stream get onDeselect => _deselectionEventController.stream;
}