part of dockable.stage;

class AnchorStream {
  StreamSubscription _mouseMove, _mouseUp, _mouseOver, _keyDown;

  String _cursor;
  String get cursor => _cursor;

  dynamic _initRect;
  dynamic get initRect => _initRect;
  Point _startPoint;
  Point get startPoint => _startPoint;

  AnchorStream(this._cursor) {
    if (_cursor == null) {
      _cursor = "default";
    }
  }

  bool _activated = false;
  bool get activated => _activated;

  bool activate(dynamic arg_initRect, Point arg_startPoint, StreamSubscription arg_mouseMove, StreamSubscription arg_mouseUp, StreamSubscription arg_mouseOver, StreamSubscription arg_keyDown) {
    bool ret = false;

    //print("activation called");

    deactivate();

    if (arg_initRect != null && arg_startPoint != null) {
      ret = true;
      _initRect = arg_initRect;
      _startPoint = arg_startPoint;

      _activated = true;

      _mouseMove = arg_mouseMove;
      _mouseUp = arg_mouseUp;
      _mouseOver = arg_mouseOver;
      _keyDown = arg_keyDown;

      //print("activating");
    }

    return ret;
  }

  void deactivate() {
    //print("deactivating");

    _initRect = null;
    _startPoint = null;

    _activated = false;

    if (_mouseMove != null) {
      _mouseMove.cancel();
      _mouseMove = null;
    }

    if (_mouseUp != null) {
      _mouseUp.cancel();
      _mouseUp = null;
    }

    if (_mouseOver != null) {
      _mouseOver.cancel();
      _mouseOver = null;
    }

    if (_keyDown != null) {
      _keyDown.cancel();
      _keyDown = null;
    }
  }
}