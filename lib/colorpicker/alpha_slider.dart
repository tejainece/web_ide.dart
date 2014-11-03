part of colorpicker;

class StreamMouseTrack {
  StreamSubscription _mousemove;
  StreamSubscription _mouseleave;
  StreamSubscription _docmouseup;
  StreamSubscription _keydown;

  StreamMouseTrack();

  void reset(StreamSubscription mousemove, StreamSubscription mouseup, StreamSubscription documentup, StreamSubscription keydown) {
    if (isCancelled) {
      cancel();
    }

    _mousemove = mousemove;
    _mouseleave = mouseup;
    _docmouseup = documentup;
    _keydown = keydown;

    _isCancelled = false;
  }

  bool _isCancelled = true;
  bool get isCancelled => _isCancelled;

  void cancel() {
    if (_mousemove != null) {
      _mousemove.cancel();
      _mousemove = null;
    }

    if (_mouseleave != null) {
      _mouseleave.cancel();
      _mouseleave = null;
    }

    if (_docmouseup != null) {
      _docmouseup.cancel();
      _docmouseup = null;
    }

    if (_keydown != null) {
      _keydown.cancel();
      _keydown = null;
    }

    _isCancelled = true;
  }
}

@CustomTag('alpha-slider')
class AlphaSlider extends PolymerElement {
  bool get preventDispose => true;

  DivElement _canvas;
  DivElement _transCanvas;
  DivElement _cursor;

  StreamMouseTrack _sstreams = new StreamMouseTrack();

  AlphaSlider.created() : super.created() {}

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

    _canvas = shadowRoot.querySelector("#canvas");
    _transCanvas = shadowRoot.querySelector("#transparent");
    _cursor = shadowRoot.querySelector("#cursor");

    _canvas.onMouseDown.listen(handleCanvasClick);

    _cursor.onMouseDown.listen(handleCursorStart);

    sizeChanged();
  }

  ColorVal _color_before;

  void handleCanvasClick(MouseEvent event) {
    handleCursorChange(event);
  }

  void handleCursorStart(MouseEvent event) {
    _sstreams.cancel();

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
        alpha = _color_before.a;
      }
    });

    _sstreams.reset(mousemove, mouseleave, docmouseup, keydown);
  }

  void handleCursorChange(MouseEvent event) {
    if (size != 0) {
      int tmp_alpha = 100;
      if (vertical) {
        tmp_alpha = (((event.offset.y - (size / 2)) / _canvas.offsetHeight) * 100).round();
      } else {
        tmp_alpha = (((event.offset.x - (size / 2)) / _canvas.offsetWidth) * 100).round();
      }

      if (tmp_alpha < 0) {
        tmp_alpha = 0;
      } else if (tmp_alpha > 100) {
        tmp_alpha = 100;
      }
      alpha = tmp_alpha;
    } else {
      alpha = 100;
    }
  }

  @published
  bool vertical = false;

  void verticalChanged() {
    //TODO: set background image

    if (vertical) {
      _canvas.style.width = "${size}px";


      _cursor.style.left = "0px";
      
      _canvas.style.background = "linear-gradient(top, rgba(${color.r}, ${color.g}, ${color.b}, 0), rgba(${color.r}, ${color.g}, ${color.b}, 1))";
    } else {
      _canvas.style.width = "calc(100%)";
      _canvas.style.height = "${size}px";

      _transCanvas.style.width = "calc(100%)";
      _transCanvas.style.height = "${size}px";

      this.style.paddingLeft = "${size/2}px";
      this.style.paddingRight = "${size/2}px";

      _cursor.style.top = "0px";
      
      _canvas.style.background = "-webkit-linear-gradient(left, rgba(${color.r}, ${color.g}, ${color.b}, 0), rgba(${color.r}, ${color.g}, ${color.b}, 1))";
    }
  }

  @published
  int size = 20;

  void sizeChanged() {
    verticalChanged();

    _cursor.style.width = "${size}px";
    _cursor.style.height = "${size}px";
  }

  @PublishedProperty(reflect: true)
  num alpha = 100;

  void alphaChanged() {
    if (vertical) {
      _cursor.style.top = "${alpha}%";

      _cursor.style.marginTop = "${-size/2}px";
    } else {
      _cursor.style.left = "${alpha}%";

      _cursor.style.marginLeft = "${-size/2}px";
    }
    _cursor.text = alpha.toString();
  }

  @PublishedProperty(reflect: true)
  ColorVal color = new ColorVal();

  void _fire_onchanged_event() {
    var event = new CustomEvent("changed", canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }

  //events
  EventStreamProvider<CustomEvent> _changedEventP = new EventStreamProvider<CustomEvent>("changed");
  Stream<CustomEvent> get onChanged => _changedEventP.forTarget(this);
}
