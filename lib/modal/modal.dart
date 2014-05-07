library modal;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import '../iconbutton/icon_button.dart';

@CustomTag('modal-window')
class ModalWindow extends PolymerElement {

  ModalWindow.created(): super.created() {
  }

  StreamSubscription<MouseEvent> mouseUpHandler;
  StreamSubscription<MouseEvent> mouseMoveHandler;

  Point _clickOffset;
  Point _initialMouse;
  Point _initialPos;

  void ready() {
    super.ready();
  }

  //drag
  void moveStarted(MouseEvent event) {
    document.body.style.userSelect = 'none';
    _clickOffset = event.offset;
    _initialMouse = event.page;
    _initialPos = new Point(offsetLeft, offsetTop);
    if (mouseMoveHandler != null) {
      mouseMoveHandler.cancel();
      mouseMoveHandler = null;
    }
    if (mouseUpHandler != null) {
      mouseUpHandler.cancel();
      mouseUpHandler = null;
    }

    mouseMoveHandler = window.onMouseMove.listen(_mousemove);
    mouseUpHandler = window.onMouseUp.listen(_mouseup);
  }

  void _mouseup(MouseEvent event) {
    _stopDragging(event);
    mouseMoveHandler.cancel();
    mouseMoveHandler = null;
    mouseUpHandler.cancel();
    mouseUpHandler = null;
  }

  void _stopDragging(MouseEvent event) {
    document.body.style.userSelect = 'all';
  }

  void _mousemove(MouseEvent event) {
    Point _currentpos = event.page;
    int dx = _currentpos.x - _initialMouse.x;
    int dy = _currentpos.y - _initialMouse.y;
    _performDrag(dx, dy);
  }

  void _performDrag(int dx, int dy) {
    int left = dx + _initialPos.x;
    int top = dy + _initialPos.y;
    this.style.left = "${left}px";
    this.style.top = "${top}px";
  }

  void closeModal() {
    show = false;
  }

  //properties
  @published
  String heading = "";

  @published
  int width = 200;
  @published
  int height = 200;
  @published
  int left = 0;
  @published
  int top = 0;

  @published
  bool show = true;

  void showChanged() {
    if (show) {
      classes.remove("hide");
    } else {
      classes.add("hide");
    }
  }
}
