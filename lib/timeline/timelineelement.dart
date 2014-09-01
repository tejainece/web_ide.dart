part of timeline;

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
  
  @published int timelinePosition = 0;
  
  @published int timelineWidth = 0;
  
  void timelinePositionChanged() {
    if(timelinePosition == null || timelinePosition < _row.getStartTime()) {
      timelinePosition = _row.getStartTime();
    } else if(timelinePosition + timelineWidth > _row.getStopTime()) {
      timelinePosition = _row.getStopTime() - timelineWidth;
    }
    performLayout();
  }
  
  void timelineWidthChanged() {
    if(timelineWidth == null || timelineWidth == 0) {
      timelineWidth = 1;
    } else if(timelinePosition + timelineWidth > _row.getStopTime()) {
      timelineWidth = _row.getStopTime() - timelinePosition;
    }
    performLayout();
  }
  
  TimelineElement.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Timeline-element');
      
  @override 
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }
  
  @override
  void attached() {
    super.attached();
    performLayout();
    _mover.onMouseDown.listen((MouseEvent e) {
      print('moving');
      if(e.button == 0 && _row != null) {
        int temp1 = e.page.x;
        int temp2 = this.offsetLeft;
        if(_trackSubscr != null) {
          _trackSubscr.cancel();
          _trackSubscr = null;
        }
        if(_trackEndSubscr != null) {
          _trackEndSubscr.cancel();
          _trackEndSubscr = null;
        }
        _trackSubscr = document.onMouseMove.listen((MouseEvent e1) {
          int newPos = temp2 + (e1.page.x - temp1);
          timelinePosition = _row.getTimeForLeft(newPos);
        });
        _trackEndSubscr = document.onMouseUp.listen((MouseEvent e2) {
          if(_trackSubscr != null) {
            _trackSubscr.cancel();
            _trackSubscr = null;
          }
          if(_trackEndSubscr != null) {
            _trackEndSubscr.cancel();
            _trackEndSubscr = null;
          }
        });
      }
    });
    
    _leftExpand.onMouseDown.listen((MouseEvent e) {
      print('left expanding');
      if(e.button == 0 && _row != null) {
        int temp1 = e.page.x;
        int temp2 = this.offsetLeft;
        if(_trackSubscr != null) {
          _trackSubscr.cancel();
          _trackSubscr = null;
        }
        if(_trackEndSubscr != null) {
          _trackEndSubscr.cancel();
          _trackEndSubscr = null;
        }
        _trackSubscr = document.onMouseMove.listen((MouseEvent e1) {
          int newPos = temp2 + (e1.page.x - temp1);
          int newTime = _row.getTimeForLeft(newPos);
          int newWidth = timelinePosition - newTime + timelineWidth;
          if(newWidth > 0 && newTime >= 0) {
            timelineWidth = newWidth;
            timelinePosition = newTime;
          }
        });
        _trackEndSubscr = document.onMouseUp.listen((MouseEvent e2) {
          if(_trackSubscr != null) {
            _trackSubscr.cancel();
            _trackSubscr = null;
          }
          if(_trackEndSubscr != null) {
            _trackEndSubscr.cancel();
            _trackEndSubscr = null;
          }
        });
      }
    });
    
    _rightExpand.onMouseDown.listen((MouseEvent e) {
      print('right expanding');
      if(e.button == 0 && _row != null) {
        int temp1 = e.page.x;
        int temp2 = this.offsetLeft;
        int initialWidth = timelineWidth;
        if(_trackSubscr != null) {
          _trackSubscr.cancel();
          _trackSubscr = null;
        }
        if(_trackEndSubscr != null) {
          _trackEndSubscr.cancel();
          _trackEndSubscr = null;
        }
        _trackSubscr = document.onMouseMove.listen((MouseEvent e1) {
          int newPos = temp2 + (e1.page.x - temp1);
          int newTime = _row.getTimeForLeft(newPos);
          int newWidth = newTime - timelinePosition + initialWidth;
          if(newWidth > 0) {
            timelineWidth = newWidth; 
          }
        });
        _trackEndSubscr = document.onMouseUp.listen((MouseEvent e2) {
          if(_trackSubscr != null) {
            _trackSubscr.cancel();
            _trackSubscr = null;
          }
          if(_trackEndSubscr != null) {
            _trackEndSubscr.cancel();
            _trackEndSubscr = null;
          }
        });
      }
    });
  }
  
  StreamSubscription<MouseEvent> _trackSubscr;
  StreamSubscription<MouseEvent> _trackEndSubscr;
  
  void performLayout() {
    if(_row != null) {
      this.style.left = "${_row.getLeftForTime(timelinePosition)}px";
      this.style.width = "${_row.getWidthForTimeInterval(timelineWidth)}px";
    }
  }
  
  TimelineRow _row;
  
  
  
  DivElement _leftExpandDiv;
  DivElement get _leftExpand {
    if(_leftExpandDiv == null) {
      _leftExpandDiv = shadowRoot.querySelector('.left-expand');
      assert(_leftExpandDiv != null);
    }
    return _leftExpandDiv;
  }
  
  DivElement _rightExpandDiv;
  DivElement get _rightExpand {
    if(_rightExpandDiv == null) {
      _rightExpandDiv = shadowRoot.querySelector('.right-expand');
      assert(_rightExpandDiv != null);
    }
    return _rightExpandDiv;
  }
  
  DivElement _moverDiv;
  DivElement get _mover {
    if(_moverDiv == null) {
      _moverDiv = shadowRoot.querySelector('.mover');
      assert(_moverDiv != null);
    }
    return _moverDiv;
  }
}
