part of timeline;

class TimelineElementData {
  String name;

  int start;

  int length;
}

/**
 * timeline-element is a ruler widget.
 *
 * Example:
 *
 *     <timeline-element></timeline-element>
 *
 * @class ruler-widget
 */
@CustomTag('timeline-element')
class TimelineElement extends PolymerElement {

  /*
     * Set to true to prevent disposal of observable bindings
     */
  bool get preventDispose => true;

  @published
  Object data;

  @published int start = 5;

  @published int length = 5;

  @published int leftlimit = 0;

  @published int rightlimit = 0;

  @published double spacing = 5.0;

  @published
  int min = 1;

  @published String label = "";

  @published
  bool editable = true;

  void startChanged() {
    if (start == null || start < leftlimit) {
      start = leftlimit;
    } else if (start + length > rightlimit) {
      start = rightlimit - length;
    }
    performLayout();
  }

  void lengthChanged() {
    if (length == null || length == 0) {
      length = 1;
    } else if (start + length > rightlimit) {
      length = rightlimit - start;
    }
    performLayout();
  }

  void leftlimitChanged() {
    startChanged();
  }

  void rightlimitChanged() {
    lengthChanged();
  }

  void spacingChanged() {
    performLayout();
  }

  TimelineElement.created() : super.created() {
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
  }

  @override
  void attached() {
    super.attached();
    performLayout();
    _mover.onMouseDown.listen((MouseEvent e) {
      if (e.button == 0 && editable) {
        int temp1 = e.page.x;
        int temp2 = this.offsetLeft;
        if (_trackSubscr != null) {
          _trackSubscr.cancel();
          _trackSubscr = null;
        }
        if (_trackEndSubscr != null) {
          _trackEndSubscr.cancel();
          _trackEndSubscr = null;
        }
        _trackSubscr = document.onMouseMove.listen((MouseEvent e1) {
          int newPos = temp2 + (e1.page.x - temp1);
          start = _getMinTimeForLeft(newPos);
        });
        _trackEndSubscr = document.onMouseUp.listen((MouseEvent e2) {
          if (_trackSubscr != null) {
            _trackSubscr.cancel();
            _trackSubscr = null;
          }
          if (_trackEndSubscr != null) {
            _trackEndSubscr.cancel();
            _trackEndSubscr = null;
          }
        });
      }
    });

    _leftExpand.onMouseDown.listen((MouseEvent e) {
      if (e.button == 0 && editable) {
        int temp1 = e.page.x;
        int temp2 = this.offsetLeft;
        if (_trackSubscr != null) {
          _trackSubscr.cancel();
          _trackSubscr = null;
        }
        if (_trackEndSubscr != null) {
          _trackEndSubscr.cancel();
          _trackEndSubscr = null;
        }
        _trackSubscr = document.onMouseMove.listen((MouseEvent e1) {
          int newPos = temp2 + (e1.page.x - temp1);
          int newTime = _getMinTimeForLeft(newPos);
          int newWidth = start - newTime + length;
          if (newWidth > 0 && newTime >= 0) {
            length = newWidth;
            start = newTime;
          }
        });
        _trackEndSubscr = document.onMouseUp.listen((MouseEvent e2) {
          if (_trackSubscr != null) {
            _trackSubscr.cancel();
            _trackSubscr = null;
          }
          if (_trackEndSubscr != null) {
            _trackEndSubscr.cancel();
            _trackEndSubscr = null;
          }
        });
      }
    });

    _rightExpand.onMouseDown.listen((MouseEvent e) {
      if (e.button == 0 && editable) {
        int temp1 = e.page.x;
        int temp2 = this.offsetLeft;
        int initialWidth = _getMinWidth(length);
        if (_trackSubscr != null) {
          _trackSubscr.cancel();
          _trackSubscr = null;
        }
        if (_trackEndSubscr != null) {
          _trackEndSubscr.cancel();
          _trackEndSubscr = null;
        }
        _trackSubscr = document.onMouseMove.listen((MouseEvent e1) {
          int newPos = temp2 + (e1.page.x - temp1);
          int newTime = _getMinTimeForLeft(newPos);
          int newWidth = _getMinWidth(newTime - start + initialWidth);
          if (newWidth > 0) {
            length = newWidth;
          }
        });
        _trackEndSubscr = document.onMouseUp.listen((MouseEvent e2) {
          if (_trackSubscr != null) {
            _trackSubscr.cancel();
            _trackSubscr = null;
          }
          if (_trackEndSubscr != null) {
            _trackEndSubscr.cancel();
            _trackEndSubscr = null;
          }
        });
      }
    });
  }

  @override
  void detached() {
    super.detached();
    if (_trackSubscr != null) {
      _trackSubscr.cancel();
      _trackSubscr = null;
    }
    if (_trackEndSubscr != null) {
      _trackEndSubscr.cancel();
      _trackEndSubscr = null;
    }
  }

  StreamSubscription<MouseEvent> _trackSubscr;
  StreamSubscription<MouseEvent> _trackEndSubscr;

  void performLayout() {
    this.style.left = "${getLeftForTime(start)}px";
    this.style.width = "${getWidthForTimeInterval(length)}px";
  }

  DivElement _leftExpandDiv;
  DivElement get _leftExpand {
    if (_leftExpandDiv == null) {
      _leftExpandDiv = shadowRoot.querySelector('.left-expand');
      assert(_leftExpandDiv != null);
    }
    return _leftExpandDiv;
  }

  DivElement _rightExpandDiv;
  DivElement get _rightExpand {
    if (_rightExpandDiv == null) {
      _rightExpandDiv = shadowRoot.querySelector('.right-expand');
      assert(_rightExpandDiv != null);
    }
    return _rightExpandDiv;
  }

  DivElement _moverDiv;
  DivElement get _mover {
    if (_moverDiv == null) {
      _moverDiv = shadowRoot.querySelector('.mover');
      assert(_moverDiv != null);
    }
    return _moverDiv;
  }

  double getLeftForTime(int arg_position) {
    return (arg_position - leftlimit) * spacing;
  }

  int _getMinTimeForLeft(int arg_left) {
    if (spacing != 0 && min != 0) {
      return _getMinTime(getTimeForLeft(arg_left));
    } else {
      return 0;
    }
  }

  int getTimeForLeft(int arg_left) {
    if (spacing != 0) {
      return (arg_left ~/ spacing) + leftlimit;
    } else {
      return 0;
    }
  }

  double getWidthForTimeInterval(int arg_interval) {
    return arg_interval * spacing;
  }

  int getTimeIntervalForWidth(int arg_interval) {
    if (spacing != 0) {
      return arg_interval ~/ spacing;
    } else {
      return 0;
    }
  }

  int _getMinTimeIntervalForWidth(int arg_interval) {
    if (spacing != 0 && min != 0) {
      return arg_interval ~/ (spacing * min);
    } else {
      return 0;
    }
  }

  int _getMinTime(int tim) {
    return (tim ~/ min) * min;
  }

  int _getMinWidth(int wid) {
    return (wid ~/ min) * min;
  }
}
