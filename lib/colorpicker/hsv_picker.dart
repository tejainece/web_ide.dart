part of colorpicker;

@CustomTag('hsv-picker')
class HsvPicker extends PolymerElement {
  /* Set to true to prevent disposal of observable bindings */
  bool get preventDispose => true;

  DivElement _hsv_canvas;

  StreamMouseTrack _sstreams = new StreamMouseTrack();

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

  ColorVal _color_before;
  Point _startPoint, _diffPoint;

  void handleCursorStart(MouseEvent event) {
    _sstreams.cancel();

    if (event.button == 0) {
      _startPoint = event.offset;
      _diffPoint = event.page;
      
      _color_before = color;

      handleCursorChange(event);

      StreamSubscription mousemove = document.onMouseMove.listen(handleCursorChange);
      StreamSubscription mouseleave = document.onMouseLeave.listen((e) {
        handleCursorChange(e);
        _sstreams.cancel();
      });
      StreamSubscription docmouseup = document.body.onMouseUp.listen((_) {
        _sstreams.cancel();
      });
      StreamSubscription keydown = document.onKeyDown.listen((e) {
        if (e.keyCode == KeyCode.ESC) {
          _sstreams.cancel();
          hue = _color_before.h;
        }
      });

      _sstreams.reset(mousemove, mouseleave, docmouseup, keydown);
    }
  }

  void handleCursorChange(MouseEvent event) {
    if(_hsv_canvas.offsetParent != null) {
      num tmp_sat = ((_startPoint.x + event.page.x - _diffPoint.x)/_hsv_canvas.offsetWidth) * 100;
      num tmp_val = 100 - (((_startPoint.y + event.page.y - _diffPoint.y) / _hsv_canvas.offsetHeight) * 100);
      
      tmp_sat = min(100, max(0, tmp_sat));
      tmp_val = min(100, max(0, tmp_val));
      
      
      saturation = tmp_sat;
      value = tmp_val;
    } else {
      saturation = 100;
      value = 100;
    }
  }

  @PublishedProperty(reflect: true)
  num saturation = 100;

  void saturationChanged() {
    _fire_onchanged_event();
  }

  @PublishedProperty(reflect: true)
  num value = 100;

  void valueChanged() {

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
    return new ColorVal.fromHSV(hue, 100, 100);
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
