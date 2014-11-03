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

  DivElement _holder;
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

    _holder = shadowRoot.querySelector("#holder");
    _canvas = shadowRoot.querySelector("#canvas");
    _transCanvas = shadowRoot.querySelector("#transparent");
    _cursor = shadowRoot.querySelector("#cursor");

    _canvas.onMouseDown.listen(handleCanvasClick);

    _cursor.onMouseDown.listen(handleCursorStart);
    
    verticalChanged();
  }

  ColorVal _color_before;

  void handleCanvasClick(MouseEvent event) {
    if (event.button == 0) {
      handleCursorChange(event);
    }
  }

  void handleCursorStart(MouseEvent event) {
    _sstreams.cancel();

    if (event.button == 0) {
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
  }

  void handleCursorChange(MouseEvent event) {
    if (_canvas.offsetParent != null) {
      int tmp_alpha = 100;
      if (vertical) {
        tmp_alpha = (((event.offset.y - 10) / _canvas.offsetHeight) * 100).round();
      } else {
        tmp_alpha = (((event.offset.x - 10) / _canvas.offsetWidth) * 100).round();
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
    if (vertical) {
      _holder.classes.add("vertical");

      _canvas.style.background = "linear-gradient(top, rgba(${color.r}, ${color.g}, ${color.b}, 0), rgba(${color.r}, ${color.g}, ${color.b}, 1))";
    } else {
      _holder.classes.remove("vertical");

      _canvas.style.background = "linear-gradient(left, rgba(${color.r}, ${color.g}, ${color.b}, 0), rgba(${color.r}, ${color.g}, ${color.b}, 1))";
    }
  }

  @PublishedProperty(reflect: true)
  num alpha = 100;

  void alphaChanged() {
    if (vertical) {
      _cursor.style.top = "${alpha}%";
    } else {
      _cursor.style.left = "${alpha}%";
    }
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
