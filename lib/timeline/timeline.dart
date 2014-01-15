library dockable.timeline;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

part 'timelinerow.dart';
part 'timelineelement.dart';

//TODO: markers are currently just numbers. make them represent time
//TODO: make the interface between timelinemanager, timelinerow and timelineelement standard

/**
 * timeline-manager is a horizontal timeline widget.
 *
 * Example:
 *
 *     <timeline-manager></timeline-manager>
 *
 * @class timeline-manager
 */
@CustomTag('timeline-manager')
class TimelineManager extends PolymerElement {
  TimelineManager.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Timeline');
  
  /**
   * The start time of the timeline.
   */
  @published int startTime;
  
  /**
   * The stop time of the timeline.
   */
  @published int stopTime;
  
  @published num zoom;
  
  void startTimeChanged() {
    if(startTime > stopTime) {
      startTime = stopTime - _stepValue;
    }
    _recalcSpacing();
  }
  
  void stopTimeChanged() {
    if(startTime > stopTime) {
      stopTime = startTime + _stepValue;
    }
    _recalcSpacing();
  }
  
  void zoomChanged() {
    if(zoom == null || zoom < 1) {
      zoom = 1;
    } else {
      //TODO: adjust position so the same content is still visible
      int oldTime = getTimeForLeft(-_scrollLeft);
      
      _timeNav.style.width = '${this.offsetWidth * zoom}px';
      _timeHolder.style.width = '${this.offsetWidth * zoom}px';
      
      _recalcSpacing();
      double newTime = getLeftForTime(oldTime);
      _scrollLeft = -newTime.toInt();
    }
  }
  
  int _stepValueVal = 1;
  int get _stepValue => _stepValueVal;
  set _stepValue(int arg_stepval) {
    if(arg_stepval == 0 || arg_stepval == null) {
      _stepValueVal = 1;
    } else {
      _stepValueVal = arg_stepval;
    }
    //performLayout();
  }
  
  int _highlightEveryVal = 10;
  int get _highlightEvery => _highlightEveryVal;
  set _highlightEvery(int arg_highlightEvery) {
    _highlightEveryVal = arg_highlightEvery;
    //performLayout();
  }
  
  int _labelEveryVal = 5;
  int get _labelEvery => _labelEveryVal;
  set _labelEvery(int arg_labelEvery) {
    _labelEveryVal = arg_labelEvery;
    //performLayout();
  }
  
  int _scrollLeftVal = 0;
  int get _scrollLeft => _timeHolder.offsetLeft;
  set _scrollLeft(int arg_scrollleft) {
    if(arg_scrollleft != null && arg_scrollleft < this.offsetWidth - 10 && arg_scrollleft + _timeHolder.offsetWidth > 10) {
    //if(arg_scrollleft != null && arg_scrollleft < 0 && arg_scrollleft + _timeHolder.offsetWidth > this.offsetWidth) {
      _timeHolder.style.left = '${arg_scrollleft}px';
      _timeNav.style.left = '${arg_scrollleft}px';
    }
    //performLayout();
  }
  
  /**
   * Show all of timeline area filling the timeline.
   */
  void showAll() {
    zoom = 1;
    _scrollLeft = 0;
  }
      
  @override 
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }
  
  @override
  void ready() {
    super.ready();
    
    _timeHolder.onMouseDown.listen((MouseEvent e) {
        //TODO: check for left click only
        int temp1 = e.page.x;
        int temp2 = _timeHolder.offsetLeft;
        _trackSubscr = this.onMouseMove.listen((MouseEvent e1) {
          _scrollLeft = temp2 + (e1.page.x - temp1);
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
    });
    
    this.onMouseWheel.listen((WheelEvent e) {
      if(e.wheelDeltaY > 0) {
        zoom = zoom * 2;
      } else {
        zoom = zoom / 2; 
      }
    });
  }
  
  @override
  void enteredView() {
    super.enteredView();
    for(Element _el in this.children) {
      /*if(_el is! TimelineRow) {
      //  _el.remove();
      } else {*/
        _timeNav.children.add(_el);
      //}
    }
    if(startTime == null) {
      startTime = 0;
    }
    if(stopTime == null) {
      stopTime = 100;
    }
    if(zoom == null) {
      zoom = 1;
    }
    _recalcSpacing();
  }
  
  @override
  void leftView() {
    super.leftView();
    if(_trackSubscr != null) {
      _trackSubscr.cancel();
      _trackSubscr = null;
    }
    if(_trackEndSubscr != null) {
      _trackEndSubscr.cancel();
      _trackEndSubscr = null;
    }
  }
  
  StreamSubscription<MouseEvent> _trackSubscr;
  StreamSubscription<MouseEvent> _trackEndSubscr;
  
  void performLayout() {
    layoutTimeMarker();
    layoutTimeLabelMinor();
    //TODO: perform layout of all its rows
    for(TimelineRow row in _timeNav.children) {
      row._manager = this;  //TODO: move this to constructor
      row.performLayout();
    }
  }
  
  void layoutTimeMarker() {
    _timeMarker.children.clear(); //TODO: instead reuse old elements
    for(int i = startTime; i <= stopTime; i+=_stepValue) {
      DivElement tempD = new DivElement()
        ..style.left = "${(i-startTime)*_spacing}px";
      if(i%_highlightEvery == 0) {
        tempD.classes.add('highlight');
      } else {
        tempD.classes.remove('highlight');
      }
      _timeMarker.children.add(tempD);
    }
  }
  
  void layoutTimeLabelMinor() {
    _timeLabelMinor.children.clear(); //TODO: instead reuse old elements
    double spanWidth = _spacing * 2;
    for(int i = startTime; i <= stopTime; i+=_labelEvery) {
      DivElement tempD = new DivElement()
        ..text = "${i}"
        ..style.left = "${(i-1-startTime) * _spacing}px"
        ..style.width = "${spanWidth}px";
      if(i%_highlightEvery == 0) {
        tempD.classes.add('highlight');
      } else {
        tempD.classes.remove('highlight');
      }
      _timeLabelMinor.children.add(tempD);
    }
  }
  
  double _spacing = 5.0;
  void _recalcSpacing() {
    _spacing = _timeMarker.offsetWidth/(stopTime - startTime);
    performLayout();
  }
  
  double getLeftForTime(int arg_position) {
    return (arg_position-startTime) * _spacing;
  }
  
  int getTimeForLeft(int arg_left) {
    if(_spacing != 0) {
      return (arg_left~/_spacing) + startTime;
    } else {
      return 0;
    }
  }
  
  double getWidthForTimeInterval(int arg_interval) {
    return arg_interval * _spacing;
  }
  
  int getTimeIntervalForWidth(int arg_interval) {
    if(_spacing != 0) {
      return arg_interval ~/ _spacing;
    } else {
      return 0;
    }
  }
  
  DivElement _timeHolderDiv;
  DivElement get _timeHolder {
    if(_timeHolderDiv == null) {
      _timeHolderDiv = shadowRoot.querySelector('.time-holder');
      assert(_timeHolderDiv != null);
    }
    return _timeHolderDiv;
  }
  
  DivElement _timeMarkerDiv;
  DivElement get _timeMarker {
    if(_timeMarkerDiv == null) {
      _timeMarkerDiv = shadowRoot.querySelector('.time-marker');
      assert(_timeMarkerDiv != null);
    }
    return _timeMarkerDiv;
  }
  
  DivElement _timeLabelMinorDiv;
  DivElement get _timeLabelMinor {
    if(_timeLabelMinorDiv == null) {
      _timeLabelMinorDiv = shadowRoot.querySelector('.time-label-minor');
      assert(_timeLabelMinorDiv != null);
    }
    return _timeLabelMinorDiv;
  }
  
  DivElement _timeNavDiv;
  DivElement get _timeNav {
    if(_timeNavDiv == null) {
      _timeNavDiv = shadowRoot.querySelector('.time-nav');
      assert(_timeNavDiv != null);
    }
    return _timeNavDiv;
  }
  
  bool addRow(TimelineRow arg_row) {
    bool ret = false;
    
    if(arg_row != null) {
      _timeNav.children.add(arg_row);
      ret = true;
    }
    
    return ret;
  }
  
  bool addRowBefore(TimelineRow arg_row) {
    return false;
  }
  
  bool removeRow(TimelineRow arg_row) {
    
  }
  
  bool indexOf(TimelineRow arg_row) {
    
  }
}
