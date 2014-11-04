part of colorpicker;

@CustomTag('hue-slider')
class HueSlider extends PolymerElement {
  bool get preventDispose => true;

  DivElement _holder;
  DivElement _canvas;
  DivElement _transCanvas;
  DivElement _cursor;

  StreamMouseTrack _sstreams = new StreamMouseTrack();

  HueSlider.created() : super.created() {}

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

    _canvas.onMouseDown.listen(_handleCanvasClick);

    //_cursor.onMouseDown.listen(_handleCursorStart);

    verticalChanged();
  }

  num _hue_before;
  Point _startPoint, _diffPoint;

  void _handleCanvasClick(MouseEvent event) {
    if (event.button == 0) {
      _hue_before = hue;

      _startPoint = event.offset;
      _diffPoint = event.page;
      
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
          hue = _hue_before;
        }
      });

      _sstreams.reset(mousemove, mouseleave, docmouseup, keydown);
    }
  }

  void _handleCursorStart(MouseEvent event) {
    _sstreams.cancel();

    if (event.button == 0) {
      _hue_before = hue;

      _startPoint = event.offset + _cursor.parent.offset.topLeft;
      _diffPoint = event.page;

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
          hue =_hue_before;
        }
      });

      _sstreams.reset(mousemove, mouseleave, docmouseup, keydown);
    }
  }

  void handleCursorChange(MouseEvent event) {
    if (_canvas.offsetParent != null) {
      int tmp_alpha = 100;
      if (vertical) {
        tmp_alpha = ((((_startPoint.y + event.page.y - _diffPoint.y)) / _canvas.offsetHeight) * 360).round();
      } else {
        tmp_alpha = ((((_startPoint.x + event.page.x - _diffPoint.x)) / _canvas.offsetWidth) * 360).round();
      }

      if (tmp_alpha < 0) {
        tmp_alpha = 0;
      } else if (tmp_alpha > 360) {
        tmp_alpha = 360;
      }
      hue = tmp_alpha;
    } else {
      hue = 360;
    }
  }

  @published
  bool vertical = false;

  void verticalChanged() {

    if (vertical) {
      _holder.classes.add("vertical");

      _canvas.style.background = "-webkit-linear-gradient(top, hsla(0, 100%, 50%, 1),hsla(10, 100%, 50%, 1),hsla(20, 100%, 50%, 1),hsla(30, 100%, 50%, 1),hsla(40, 100%, 50%, 1),hsla(50, 100%, 50%, 1),hsla(60, 100%, 50%, 1),hsla(70, 100%, 50%, 1),hsla(80, 100%, 50%, 1),hsla(90, 100%, 50%, 1),hsla(100, 100%, 50%, 1),hsla(110, 100%, 50%, 1),hsla(120, 100%, 50%, 1),hsla(130, 100%, 50%, 1),hsla(140, 100%, 50%, 1),hsla(150, 100%, 50%, 1),hsla(160, 100%, 50%, 1),hsla(170, 100%, 50%, 1),hsla(180, 100%, 50%, 1),hsla(190, 100%, 50%, 1),hsla(200, 100%, 50%, 1),hsla(210, 100%, 50%, 1),hsla(220, 100%, 50%, 1),hsla(230, 100%, 50%, 1),hsla(240, 100%, 50%, 1),hsla(250, 100%, 50%, 1),hsla(260, 100%, 50%, 1),hsla(270, 100%, 50%, 1),hsla(280, 100%, 50%, 1),hsla(290, 100%, 50%, 1),hsla(300, 100%, 50%, 1),hsla(310, 100%, 50%, 1),hsla(320, 100%, 50%, 1),hsla(330, 100%, 50%, 1),hsla(340, 100%, 50%, 1),hsla(350, 100%, 50%, 1),hsla(360, 100%, 50%, 1))";
    } else {
      _holder.classes.remove("vertical");

      _canvas.style.background = "-webkit-linear-gradient(left, hsla(0, 100%, 50%, 1),hsla(10, 100%, 50%, 1),hsla(20, 100%, 50%, 1),hsla(30, 100%, 50%, 1),hsla(40, 100%, 50%, 1),hsla(50, 100%, 50%, 1),hsla(60, 100%, 50%, 1),hsla(70, 100%, 50%, 1),hsla(80, 100%, 50%, 1),hsla(90, 100%, 50%, 1),hsla(100, 100%, 50%, 1),hsla(110, 100%, 50%, 1),hsla(120, 100%, 50%, 1),hsla(130, 100%, 50%, 1),hsla(140, 100%, 50%, 1),hsla(150, 100%, 50%, 1),hsla(160, 100%, 50%, 1),hsla(170, 100%, 50%, 1),hsla(180, 100%, 50%, 1),hsla(190, 100%, 50%, 1),hsla(200, 100%, 50%, 1),hsla(210, 100%, 50%, 1),hsla(220, 100%, 50%, 1),hsla(230, 100%, 50%, 1),hsla(240, 100%, 50%, 1),hsla(250, 100%, 50%, 1),hsla(260, 100%, 50%, 1),hsla(270, 100%, 50%, 1),hsla(280, 100%, 50%, 1),hsla(290, 100%, 50%, 1),hsla(300, 100%, 50%, 1),hsla(310, 100%, 50%, 1),hsla(320, 100%, 50%, 1),hsla(330, 100%, 50%, 1),hsla(340, 100%, 50%, 1),hsla(350, 100%, 50%, 1),hsla(360, 100%, 50%, 1))";
    }
  }

  @PublishedProperty(reflect: true)
  num hue = 100;

  void hueChanged() {
    if (vertical) {
      _cursor.style.top = "${hue * 100 / 360}%";
    } else {
      _cursor.style.left = "${hue * 100 / 360}%";
    }
    //print("hue ${hue}");
  }

  void _fire_onchanged_event() {
    var event = new CustomEvent("changed", canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }

  //events
  EventStreamProvider<CustomEvent> _changedEventP = new EventStreamProvider<CustomEvent>("changed");
  Stream<CustomEvent> get onChanged => _changedEventP.forTarget(this);
}
