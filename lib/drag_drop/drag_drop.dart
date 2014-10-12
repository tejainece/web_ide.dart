library drag_drop;

import 'dart:html';

class CanDropType {
  
  CanDropType(this._instance, this._isReorder) {
    
  }
  
  Object _instance;
  Object get instance => _instance;
  bool _isReorder;
  bool get isReorder => _isReorder;
}

typedef bool DnDDropType(CanDropType droptype);

class DragData {
  Object _data;
  Element _element;
  Object _source;
  int _index;
  
  bool _has;

  DragData() {
    _has = false;
  }

  void set(Object data, Element element, Object source, int index) {
    _data = data;
    _element = element;
    _source = source;
    _index = index;
    
    _has = true;
  }

  void remove() {
    _data = null;
    _element = null;
    _source = null;
    _has = false;
  }

  bool hasData() {
    return _has;
  }

  Object getData() {
    return _data;
  }

  Element getElement() {
    return _element;
  }
  
  Object get source => _source;
  
  int get index => _index;
}

DragData _dragdata = new DragData();
void setDragData(Object data, Element element, Object source, int index) {
  _dragdata.set(data, element, source, index);
}

void removeDragData() {
  _dragdata.remove();
}

bool hasDragData() {
  return _dragdata.hasData();
}

Object getDragData() {
  return _dragdata.getData();
}

Element getDragElement() {
  return _dragdata.getElement();
}

Element getDragSource() {
  return _dragdata.source;
}

int getDragDataIndex() {
  return _dragdata.index;
}