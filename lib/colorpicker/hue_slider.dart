part of colorpicker;

@CustomTag('hue-slider')
class HueSlider extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  CanvasElement _hue_canvas;

  HueSlider.created(): super.created() {
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
    verticalChanged();
  }

  @override
  void ready() {
    super.ready();

    _hue_canvas = shadowRoot.querySelector(".hue-canvas");
    assert(_hue_canvas != null);
  }

  @override
  void leftView() {
    super.leftView();
    stopCursorChange();
  }

  StreamSubscription _mousemove;
  StreamSubscription _mouseup;
  StreamSubscription _mouseleft;
  StreamSubscription _keydown;
  int _hue_before_mod;
  void handleCursorStart(MouseEvent event) {
    stopCursorChange();
    _hue_before_mod = hue;
    handleCursorChange(event);
    _mousemove = _hue_canvas.onMouseMove.listen(handleCursorChange);
    _mouseup = _hue_canvas.onMouseUp.listen((e) {
      handleCursorChange(e);
      stopCursorChange();
    });
    _keydown = document.onKeyDown.listen((e) {
      if (e.keyCode == KeyCode.ESC) {
        stopCursorChange();
        hue = _hue_before_mod;
      }
    });
    _mouseleft = _hue_canvas.onMouseLeave.listen((_) {
      stopCursorChange();
      hue = _hue_before_mod;
    });
  }

  void handleCursorChange(MouseEvent event) {
    int pos;
    num ratio;
    if (vertical) {
      pos = event.offset.y;
      pos %= _hue_canvas.offsetHeight;
      ratio = pos / _hue_canvas.offsetHeight;
    } else {
      pos = event.offset.x;
      pos %= _hue_canvas.offsetWidth;
      ratio = pos / _hue_canvas.offsetWidth;
    }

    hue = (360 * ratio).toInt();

    _fire_onchanged_event();
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

  /** The cached gradient object that represents the hue colors */
  CanvasGradient gradient;

  /*
   * This is called everytime height is changed to build a cached version
   * of hue gradient.
   */
  void _buildGradient() {
    var hueColors = [new ColorVal.fromRGB(255, 0, 0), new ColorVal.fromRGB(255,
        255, 0), new ColorVal.fromRGB(0, 255, 0), new ColorVal.fromRGB(0, 255, 255),
        new ColorVal.fromRGB(0, 0, 255), new ColorVal.fromRGB(255, 0, 255),
        new ColorVal.fromRGB(255, 0, 0)];
    final CanvasRenderingContext2D context = _hue_canvas.context2D;

    if (vertical) {
      // Create a hue color gradient object to draw in the canvas
      gradient = context.createLinearGradient(0, 0, 0, _hue_canvas.height);
    } else {
      // Create a hue color gradient object to draw in the canvas
      gradient = context.createLinearGradient(0, 0, _hue_canvas.width, 0);
    }

    final gradientStopDelta = 1 / (hueColors.length - 1);
    // Calculate the gradient stop delta for each color
    num gradientStop = 0;
   for (var i = 0; i < hueColors.length - 1; i++) {
     gradient.addColorStop(gradientStop, hueColors[i].toString());
     gradientStop += gradientStopDelta;
   }
    // Add the last one manually to avoid precision issues
    gradient.addColorStop(1.0, hueColors.last.toString());

    updateCursor();
  }

  /*
   * Redraw the canvas everytime width, height or selected color
   * changes.
   */
  void updateCursor() {
    final CanvasRenderingContext2D context = _hue_canvas.context2D;
    context.fillStyle = gradient;
    context.fillRect(0, 0, _hue_canvas.width, _hue_canvas.height);

    // Find the appropriate color for the cursor
    String cursorColor = "black";

    // Find the hue color
    ColorVal hueColor = hueAsColor;

    // get luma of of the hue color
    final num hueLuma = hueColor.luma;
    if (hueLuma < 0.5) {
      // Color is too dark in this region.  Choose a bright cursor color
      cursorColor = "white";
    }

    if(vertical) {
      // Draw the cursor at the current hue
      final y = _hue_canvas.height * hue / (360) + 0.5;
      context.save();
      context.strokeStyle = cursorColor;
      context.lineWidth = 2;
      context.beginPath();
      context.moveTo(0, y);
      context.lineTo(_hue_canvas.width, y);
      context.closePath();
      context.stroke();

      // Draw rectangles on the side
      final triangleSize = 4;
      context.fillStyle = cursorColor;
      // Draw the left triangle
      context.beginPath();
      context.moveTo(0, y - triangleSize);
      context.lineTo(triangleSize, y);
      context.lineTo(0, y + triangleSize);
      context.closePath();
      context.fill();

      // Draw the right triangle
      context.beginPath();
      context.moveTo(_hue_canvas.width, y - triangleSize);
      context.lineTo(_hue_canvas.width - triangleSize, y);
      context.lineTo(_hue_canvas.width, y + triangleSize);
      context.closePath();
      context.fill();
      context.restore();
    } else {
      // Draw the cursor at the current hue
      final x = _hue_canvas.width * hue / (360) + 0.5;
      context.save();
      context.strokeStyle = cursorColor;
      context.lineWidth = 2;
      context.beginPath();
      context.moveTo(x, 0);
      context.lineTo(x, _hue_canvas.height);
      context.closePath();
      context.stroke();

      // Draw rectangles on the side
      final triangleSize = 4;
      context.fillStyle = cursorColor;
      // Draw the left triangle
      context.beginPath();
      context.moveTo(x - triangleSize, 0);
      context.lineTo(x, triangleSize);
      context.lineTo(x + triangleSize, 0);
      context.closePath();
      context.fill();

      // Draw the right triangle
      context.beginPath();
      context.moveTo(x - triangleSize, _hue_canvas.height);
      context.lineTo(x, _hue_canvas.height - triangleSize);
      context.lineTo(x + triangleSize, _hue_canvas.height);
      context.closePath();
      context.fill();
      context.restore();
    }
  }

  @published
  int breadth = 16;
  @published
  int size = 100;
  /*
   * Hue angle in  radian.
   */
  @published
  int hue = 180;

  @published
  bool vertical = true;

  ColorVal get hueAsColor {
    return hueAngleToColorVal(hue);
  }

  void breadthChanged() {
    if(vertical) {
      _hue_canvas.width = breadth;
    } else {
      _hue_canvas.height = breadth;
    }
    //rebuild cache everytime width changes
    _buildGradient();
  }

  void sizeChanged() {
    if(vertical) {
      _hue_canvas.height = size;
    } else {
      _hue_canvas.width = size;
    }
    //rebuild cache everytime height changes
    _buildGradient();
  }

  void hueChanged() {
    //update the cursor position
    updateCursor();
    _fire_onchanged_event();
  }

  void verticalChanged() {
    if (vertical) {
      classes.add("vertical");
      _hue_canvas.width = breadth;
      _hue_canvas.height = size;
    } else {
      classes.remove("vertical");
      _hue_canvas.width = size;
      _hue_canvas.height = breadth;
    }

    _buildGradient();
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
