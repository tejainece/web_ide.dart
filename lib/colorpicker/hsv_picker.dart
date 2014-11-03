part of colorpicker;

@CustomTag('hsv-picker')
class HsvPicker extends PolymerElement {
  /* Set to true to prevent disposal of observable bindings */
  bool get preventDispose => true;

  DivElement _hsv_canvas;

  HsvPicker.created() : super.created() {}

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void attached() {
    super.attached();
  }

  @override
  void ready() {
    super.ready();

    _hsv_canvas = shadowRoot.querySelector("#hsv-canvas");

    _hsv_canvas.onMouseDown.listen(handleCursorStart);
  }

  StreamSubscription _mousemove;
  StreamSubscription _mouseup;
  StreamSubscription _docmouseup;
  StreamSubscription _keydown;
  ColorVal _color_before;
  void handleCursorStart(MouseEvent event) {
    stopCursorChange();
    _color_before = color;
    handleCursorChange(event);
    _mousemove = _hsv_canvas.onMouseMove.listen(handleCursorChange);
    _mouseup = _hsv_canvas.onMouseUp.listen((e) {
      handleCursorChange(e);
      stopCursorChange();
    });
    _docmouseup = document.body.onMouseUp.listen((_) {
      stopCursorChange();
    });
    _keydown = document.onKeyDown.listen((e) {
      if (e.keyCode == KeyCode.ESC) {
        stopCursorChange();
        hue = _color_before.h;
        saturation = _color_before.s;
        value = _color_before.v;
      }
    });
  }

  void handleCursorChange(MouseEvent event) {
    if (size != 0) {
      saturation = ((event.offset.x / size) * 255).round();
      value = ((1 - (event.offset.y / size)) * 255).round();
      //print("sat val ${hue} ${saturation} ${value}");
    } else {
      saturation = 255;
      value = 255;
    }
  }

  void stopCursorChange() {
    if (_mousemove != null) {
      _mousemove.cancel();
      _mousemove = null;
    }

    if (_mouseup != null) {
      _mouseup.cancel();
      _mouseup = null;
    }

    if (_docmouseup != null) {
      _docmouseup.cancel();
      _docmouseup = null;
    }

    if (_keydown != null) {
      _keydown.cancel();
      _keydown = null;
    }
  }

  @PublishedProperty(reflect: true)
  int size = 100;

  void sizeChanged() {
    notifyPropertyChange(#cursorX, null, cursorX);
    notifyPropertyChange(#cursorY, null, cursorY);
  }

  @PublishedProperty(reflect: true)
  num saturation = 100;

  @observable
  int get cursorX => ((saturation/255) * size).round();

  void saturationChanged() {
    notifyPropertyChange(#cursorX, null, cursorX);

    _fire_onchanged_event();
  }

  @PublishedProperty(reflect: true)
  num value = 100;

  @observable
  int get cursorY => ((1 - (value/255)) * size).round();

  void valueChanged() {
    notifyPropertyChange(#cursorY, null, cursorY);

    _fire_onchanged_event();
  }

  @PublishedProperty(reflect: true)
  num hue = 0;

  void hueChanged() {
    if (hue == null) {
      hue = 0;
    } else {
      notifyPropertyChange(#hueAsColor, new ColorVal(), hueAsColor);

      _fire_onchanged_event();
    }
  }

  @observable
  ColorVal get hueAsColor {
    return new ColorVal.fromHSV(hue, 255, 255);
  }

  ColorVal get color => new ColorVal.fromHSV(hue, saturation, value);

  void _fire_onchanged_event() {
    var event = new CustomEvent("changed", canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }

  //events
  EventStreamProvider<CustomEvent> _changedEventP = new EventStreamProvider<CustomEvent>("changed");
  Stream<CustomEvent> get onChanged => _changedEventP.forTarget(this);
}
