library drag_drop;

import 'dart:html';

class DragData {
  Object _data;
  Element _element;
  bool _has;

  DragData() {
    _has = false;
  }

  void set(Object data, Element element) {
    _data = data;
    _element = element;
    _has = true;
  }

  void remove() {
    _data = null;
    _element = null;
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
}

DragData _dragdata = new DragData();
void setDragData(Object data, Element element) {
  _dragdata.set(data, element);
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