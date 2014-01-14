// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see 
// the AUTHORS file for details. All rights reserved. Use of this source code is 
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project, 
// http://www.polymer-project.org/. 
library dockable.timeline;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

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
  @published int startTime = 0;
  
  /**
   * The stop time of the timeline.
   */
  @published int stopTime = 100;
      
  @override 
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }
  
  @override
  void ready() {
    super.ready();
  }
  
  @override
  void enteredView() {
    super.enteredView();
    layoutTimeMarker();
    layoutTimeLabelMinor();
  }
  
  void layoutTimeMarker() {
    for(int i = startTime; i < stopTime; i++) {
      DivElement tempD = new DivElement()
        ..style.left = "${i*_spacing}px";
      if(i%_markerHighlight == 0) {
        tempD.classes.add('highlight');
      } else {
        tempD.classes.remove('highlight');
      }
      _timeMarker.children.add(tempD);
    }
  }
  
  void layoutTimeLabelMinor() {
    int spanWidth = _spacing * 2;
    for(int i = startTime; i < stopTime; i+=5) {
      SpanElement tempD = new SpanElement()
        ..text = "${i}"
        ..style.left = "${(i-1) * _spacing}px"
        ..style.width = "${spanWidth}px";
      if(i%_labelMinorHighlight == 0) {
        tempD.classes.add('highlight');
      } else {
        tempD.classes.remove('highlight');
      }
      _timeLabelMinor.children.add(tempD);
    }
  }
  
  int _spacing = 5;
  int _markerHighlight = 5;
  int _labelMinorHighlight = 2;
  
  DivElement _timeMarkerDiv;
  DivElement get _timeMarker {
    return shadowRoot.querySelector('.time-marker');
  }
  
  DivElement get _timeLabelMinor {
    return shadowRoot.querySelector('.time-label-minor');
  }
}
