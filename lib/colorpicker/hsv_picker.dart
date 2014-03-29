part of colorpicker;

@CustomTag('hsv-picker')
class HsvPicker extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  CanvasElement _hsv_canvas;

  HsvPicker.created(): super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Dockable.HsvPicker');

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void enteredView() {
    super.enteredView();
    sizeChanged();
  }

  @override
  void ready() {
    super.ready();

    _hsv_canvas = shadowRoot.querySelector(".hsv-canvas");
    assert(_hsv_canvas != null);

    _hsv_canvas.onMouseDown.listen(handleCursorStart);

    context = _hsv_canvas.context2D;
  }

  void _setCursorPosition(int x, int y) {
    // Get the cursor bounds clamped to the canvas rectangle
    _cursorX = x;
    _cursorY = y;
    _recalculateColorFromCursor();
    updateCursor();
  }

  void _recalculateColorFromCursor() {
    num saturation = _cursorX / _hsv_canvas.width;
    num value = (_hsv_canvas.height - _cursorY) / _hsv_canvas.height;

    color = new ColorVal.fromHSV(color.h, saturation, value);
  }

  CanvasRenderingContext2D context;
  ImageData buffer;
  /** Rebuilds the grandient in the buffer image */
  void _rebuildGradient() {
    buffer = context.createImageData(_hsv_canvas.width, _hsv_canvas.height);
    final int height = buffer.height;
    final int width = buffer.width;
    final double intensityDelta = 1 / (width - 1);
    final List<int> _buffer = buffer.data;
    int index = 0;
    for (int h = 0; h < height; h++) {
      num intensity = (height - 1 - h) / (height - 1);
      int greyScaleComponent = (255 * intensity).toInt();
      var startColor = new ColorVal.fromRGB(greyScaleComponent,
          greyScaleComponent, greyScaleComponent);
      var endColor = _hueAsColor * intensity;
      num pixelIntensity = 0;
      for (var w = 0; w < width; w++) {
        final pixelColor = startColor + (endColor - startColor) *
            pixelIntensity;
        _buffer[index++] = pixelColor.r;
        _buffer[index++] = pixelColor.g;
        _buffer[index++] = pixelColor.b;
        _buffer[index++] = 255;
        pixelIntensity += intensityDelta;
      }
    }
    updateCursor();
  }

  final cursorRadius = 4;
  // The cursor position
  int _cursorX = 0;
  int _cursorY = 0;

  /* Draws the cursor on the currently selected color position */
  void updateCursor() {
    context.putImageData(buffer, 0, 0);
    // Find out the luminosity of the selected color to choose an
    // appropriate color for the cursor
    final num luma = color.luma;
    var cursorColor = "black";
    if (luma < 0.5) {
      // color around this area is too dark. make the cursor color white
      cursorColor = "white";
    }
    context.strokeStyle = cursorColor;
    context.beginPath();
    context.arc(_cursorX, _cursorY, cursorRadius, 0 , 2 * PI, false);
    context.closePath();
    context.stroke();
  }

  StreamSubscription _mousemove;
  StreamSubscription _mouseup;
  StreamSubscription _mouseleft;
  StreamSubscription _keydown;
  ColorVal _color_before;
  void handleCursorStart(MouseEvent event) {
    stopCursorChange();
    _color_before = new ColorVal.copy(color);
    handleCursorChange(event);
    _mousemove = _hsv_canvas.onMouseMove.listen(handleCursorChange);
    _mouseup = _hsv_canvas.onMouseUp.listen((e) {
      handleCursorChange(e);
      stopCursorChange();
    });
    _keydown = document.onKeyDown.listen((e) {
      if (e.keyCode == KeyCode.ESC) {
        stopCursorChange();
        color = _color_before;
      }
    });
    _mouseleft = _hsv_canvas.onMouseLeave.listen((_) {
      stopCursorChange();
      color = _color_before;
    });
  }

  void handleCursorChange(MouseEvent event) {
    _setCursorPosition(event.offset.x, event.offset.y);
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

    if (_mouseleft != null) {
      _mouseleft.cancel();
      _mouseleft = null;
    }

    if (_keydown != null) {
      _keydown.cancel();
      _keydown = null;
    }
  }

  @published
  int size = 100;

  void sizeChanged() {
    _hsv_canvas.width = size;
    _hsv_canvas.height = size;
    _rebuildGradient();
  }

  set hue(int hue_angle) {
    color = new ColorVal.fromHSV(hue_angle, color.s, color.v);
  }

  ColorVal get _hueAsColor {
    return hueAngleToColorVal(color.h);
  }

  ColorVal _color = new ColorVal.fromRGB(255, 0, 0);

  void set color(ColorVal arg_color) {
    if(arg_color != null) {
      _color = arg_color;

      //calculate the position of the cursor in the canvas
      _cursorX = (_hsv_canvas.width * color.s).toInt();
      _cursorY = (_hsv_canvas.height * (1 - color.v)).toInt();

      _rebuildGradient();
      _fire_onchanged_event();
    }
  }

  ColorVal get color {
    return _color;
  }

  void _fire_onchanged_event() {
    //TODO: send valid detail
    var event = new CustomEvent("changed",
            canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }

  //events
  EventStreamProvider<CustomEvent> _changedEventP = new EventStreamProvider<CustomEvent>("changed");
  Stream<CustomEvent> get onChanged =>
      _changedEventP.forTarget(this);
}
