@HtmlImport('ruler.html')
library ruler;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

/**
 * ruler-widget is a ruler widget.
 *
 * Example:
 *
 *     <ruler-widget></timeline-manager>
 *
 * @class ruler-widget
 */
@CustomTag('ruler-widget')
class RulerWidget extends PolymerElement {
  RulerWidget.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Timeline');
  
  /**
   * Beginning value of the ruler.
   */
  @published int startValue = 0;
  
  /**
   * Final value of the ruler.
   */
  @published int stopValue = 100;
  
  /**
   * Value of the individual steps of the ruler.
   */
  @published int stepValue = 1;
  
  /**
   * Interval at which the markings are highlighted.
   */
  @published int highlightEvery = 10;
  
  /**
   * Interval at which the markings are labelled.
   */
  @published int labelEvery = 5;
  
  void startValueChanged() {
    if(startValue > stopValue) {
      startValue = stopValue - stepValue;
    }
    _recalcSpacing();
  }
  
  void stopValueChanged() {
    if(startValue > stopValue) {
      stopValue = startValue + stepValue;
    }
    _recalcSpacing();
  }
  
  void stepValueChanged() {
    if(stepValue == 0) {
      stepValue = 1;
    }
    performLayout();
  }
  
  void highlightEveryChanged() {
    performLayout();
  }
  
  void labelEveryChanged() {
    performLayout();
  }
      
  @override 
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }
  
  @override
  void attached() {
    super.attached();
    _recalcSpacing();
  }
  
  void performLayout() {
    layoutTimeMarker();
    layoutTimeLabelMinor();
  }
  
  void layoutTimeMarker() {
    for(int i = startValue; i <= stopValue; i+=stepValue) {
      DivElement tempD = new DivElement()
        ..style.left = "${(i-startValue)*_spacing}px";
      if(i%highlightEvery == 0) {
        tempD.classes.add('highlight');
      } else {
        tempD.classes.remove('highlight');
      }
      _timeMarker.children.add(tempD);
    }
  }
  
  void layoutTimeLabelMinor() {
    double spanWidth = _spacing * 2;
    for(int i = startValue; i <= stopValue; i+=labelEvery) {
      SpanElement tempD = new SpanElement()
        ..text = "${i}"
        ..style.left = "${(i-1-startValue) * _spacing}px"
        ..style.width = "${spanWidth}px";
      if(i%highlightEvery == 0) {
        tempD.classes.add('highlight');
      } else {
        tempD.classes.remove('highlight');
      }
      _timeLabelMinor.children.add(tempD);
    }
  }
  
  
  double _spacing = 5.0;
  void _recalcSpacing() {
    _spacing = this.offsetWidth/(stopValue - startValue);
    performLayout();
  }
  
  DivElement _timeMarkerDiv;
  DivElement get _timeMarker {
    return shadowRoot.querySelector('.marker');
  }
  
  DivElement get _timeLabelMinor {
    return shadowRoot.querySelector('.label');
  }
}
