part of timeline;

/**
 * timeline-row is a ruler widget.
 *
 * Example:
 *
 *     <timeline-row></timeline-row>
 *
 * @class ruler-widget
 */
@CustomTag('timeline-row')
class TimelineRow extends PolymerElement {
  TimelineRow.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Timeline-row');
      
  @override 
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }
  
  @override
  void attached() {
    super.attached();
    //for(Element _el in this.children) {
      /*if(_el is! TimelineElement) {
      //  _el.remove();
      } else {*/
        //shadowRoot.children.add(_el);
      //}
    //}
    performLayout();
  }
  
  void performLayout() {
    if(_manager != null) {
      for(TimelineElement _el in this.children) {
        _el._row = this; //TODO: move to constructor
        _el.performLayout();
      }
    }
  }
  
  TimelineManager _manager;
  double getLeftForTime(int arg_position) {
    if(_manager != null) {
      return _manager.getLeftForTime(arg_position);
    } else {
      return 0.0;
    }
  }
  
  int getTimeForLeft(int arg_left) {
    if(_manager != null) {
      return _manager.getTimeForLeft(arg_left);
    } else {
      return 0;
    }
  }
  
  double getWidthForTimeInterval(int arg_interval) {
    if(_manager != null) {
      return _manager.getWidthForTimeInterval(arg_interval);
    } else {
      return 0.0;
    }
  }
  
  int getTimeIntervalForWidth(int arg_interval) {
    if(_manager != null) {
      return _manager.getTimeIntervalForWidth(arg_interval);
    } else {
      return 0;
    }
  }
  
  int getStartTime() {
    if(_manager != null) {
      return _manager.startTime;
    } else {
      return 0;
    }
  }
  
  int getStopTime() {
    if(_manager != null) {
      return _manager.stopTime;
    } else {
      return 0;
    }
  }
  
  @published String title = "";
}
