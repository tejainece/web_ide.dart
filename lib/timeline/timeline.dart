library timeline;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';
import '../drag_drop/drag_drop.dart';

import 'package:dockable/ordered_list/ordered_list.dart';

part 'timelineelement.dart';
part 'timelinerow.dart';

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

  /*
     * Set to true to prevent disposal of observable bindings
     */
  bool get preventDispose => true;

  OrderedList _list;
  DivElement _rowHold;
  DivElement _timeHolder;
  DivElement _timeMarker;
  DivElement _timeLabelMinor;
  DivElement _timeNav;

  TimelineManager.created() : super.created() {
  }

  /**
   * The start time of the timeline.
   */
  @published int start = 0;

  /**
   * The stop time of the timeline.
   */
  @published int end = 86400; //1440;

  @published num zoom = 1;

  @published
  ObservableList data;

  @published
  bool editable = true;

  void startTimeChanged() {
    zoomChanged();
  }

  void stopTimeChanged() {
    zoomChanged();
  }

  num get _min_width => 0.015625 * (end - start);
  num get _max_width => 64 * (end - start);

  void printTime(int t) {
    print("${t~/(60*60)}:${(t~/(60)) % 60}");
  }

  void zoomChanged() {
    if (zoom == null) {
    } else {

      num new_width = _min_width * zoom;

      if (new_width > _max_width) {
        zoom = zoom / 2;
      } else if (new_width < _min_width) {
        zoom = 1;
      } else {
        int oldStartTime = getTimeForLeft(-_scrollLeft);
        int oldMidTime = oldStartTime + getTimeIntervalForWidth(_rowHold.offsetWidth ~/ 2);

        _timeNav.style.width = '${new_width}px';
        _timeHolder.style.width = '${new_width}px';

        _recalcSpacing();
        double newMidLeft = getLeftForTime(oldMidTime) - _rowHold.offsetWidth ~/ 2;
        //double newTime = getLeftForTime(oldTime);
        _scrollLeft = -newMidLeft.toInt();
      }
    }
  }

  @observable
  int get mainheight {
    int ret = 0;
    if (data != null) {
      ret = data.length * 32;
    }
    return ret;
  }

  void dataChanged() {
    notifyPropertyChange(#mainheight, 0, mainheight);
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _list = shadowRoot.querySelector("#time-info");

    _timeHolder = shadowRoot.querySelector('.time-holder');
    _timeMarker = shadowRoot.querySelector('.time-marker');
    _timeLabelMinor = shadowRoot.querySelector('.time-label-minor');
    _timeNav = shadowRoot.querySelector('.time-nav');

    _rowHold = shadowRoot.querySelector("#ab-row-hold");

    this.onMouseWheel.listen((WheelEvent e) {
      if (e.ctrlKey && e.shiftKey) {
        if (e.deltaX > 0) {
          zoom = zoom / 2;
        } else {
          zoom = zoom * 2;
        }
      }
    });

    if (start == null) {
      start = 0;
    }
    if (end == null) {
      end = 100;
    }
    if (zoom == null) {
      zoom = 1;
    } else {
      zoomChanged();
    }
  }

  @override
  void attached() {
    super.attached();

    _timeHolder.onMouseDown.listen((MouseEvent e) {
      if (e.button == 0) {
        int temp1 = e.page.x;
        int temp2 = _timeHolder.offsetLeft;
        _trackSubscr = this.onMouseMove.listen((MouseEvent e1) {
          _scrollLeft = temp2 + (e1.page.x - temp1);
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

    zoomChanged();

    _scrollLeft = 0;
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

  int get _scrollLeft => _timeHolder.offsetLeft;
  set _scrollLeft(int arg_scrollleft) {
    if (arg_scrollleft != null && arg_scrollleft < _rowHold.offsetWidth - 10 && arg_scrollleft + _timeHolder.offsetWidth > 10) {
      _timeHolder.style.left = '${arg_scrollleft}px';
      _timeNav.style.left = '${arg_scrollleft}px';
      performLayout();
    } else {
      arg_scrollleft = 0;
    }
  }

  /**
   * Show all of timeline area filling the timeline.
   */
  void showAll() {
    zoom = 1;
    _scrollLeft = 0;
  }

  void scrollLeftToTime(int time) {
    if (time > end) {
      time = end - 10;
    }

    if (time < start) {
      time = start;
    }

    _scrollLeft = getTimeForLeft(time);
  }

  void performLayout() {
    layoutTimeMarker();
    layoutTimeLabelMinor();
  }

  int _largeMarkerInterval = 15;
  int _labelEvery = 1;
  int _markEveryVal = 1;
  @observable
  int get markevery => _markEveryVal;
  set _markEvery(int new_m) {
    _markEveryVal = notifyPropertyChange(#markevery, _markEveryVal, new_m);
  }

  bool _showSeconds = false;

  void layoutTimeMarker() {
    _timeMarker.children.clear(); //TODO: instead reuse old elements

    int st;
    if (_scrollLeft < 0) {
      st = getTimeForLeft(-_scrollLeft);
    } else {
      st = 0;
    }
    int et = st + getTimeIntervalForWidth(this.offsetWidth);

    st = (st ~/ markevery) * markevery;
    et = ((et / markevery) * markevery).ceil();

    for (int i = st; i <= et; i += markevery) {
      DivElement tempD = new DivElement()..style.left = "${(i-start)*spacing}px";
      if (i % _largeMarkerInterval == 0) {
        tempD.classes.add('highlight');
      } else {
        tempD.classes.remove('highlight');
      }
      _timeMarker.children.add(tempD);
    }
  }

  void layoutTimeLabelMinor() {
    _timeLabelMinor.children.clear(); //TODO: instead reuse old elements

    int st;
    if (_scrollLeft < 0) {
      st = getTimeForLeft(-_scrollLeft);
    } else {
      st = 0;
    }
    int et = st + getTimeIntervalForWidth(this.offsetWidth);

    st = (st ~/ _labelEvery) * _labelEvery;
    et = ((et / _labelEvery) * _labelEvery).ceil();

    double spanWidth = spacing * 2 * _labelEvery;
    int hour_marker = -1;
    int min_marker = -1;
    int second_marker = -1;
    for (int i = st; i <= et; i += _labelEvery) {

      min_marker = (i ~/ 60) % 60;
      hour_marker = (i ~/ (60 * 60));// % 24;
      second_marker = i % 60;

      String lab = "${min_marker}";

      if (_showSeconds) {
        lab += ":${second_marker}";
      }

      DivElement tempD = new DivElement()
          ..style.left = "${(i-_labelEvery-start) * spacing}px"
          ..style.width = "${spanWidth}px";
      if (i % _largeMarkerInterval == 0) {
        tempD.classes.add('highlight');
        lab = "${hour_marker}:" + lab;
      } else {
        tempD.classes.remove('highlight');
      }
      tempD.text = lab;
      _timeLabelMinor.children.add(tempD);
    }
  }

  @observable
  double spacing = 10.0;

  void _recalcSpacing() {
    spacing = _timeMarker.offsetWidth / (end - start);

    if (spacing < 0.0625) {
      _markEvery = 60 * 15;
      _labelEvery = 60 * 15;
      _largeMarkerInterval = 60 * 60;
      _showSeconds = false;
    } else if (spacing < 0.125) {
      _markEvery = 60 * 5;
      _labelEvery = 60 * 5;
      _largeMarkerInterval = 60 * 60;
      _showSeconds = false;
    } else if (spacing < 0.5) {
      _markEvery = 60 * 2;
      _labelEvery = 60 * 2;
      _largeMarkerInterval = 60 * 30;
      _showSeconds = false;
    } else if (spacing < 1) {
      _markEvery = 60;
      _labelEvery = 60;
      _largeMarkerInterval = 60 * 15;
      _showSeconds = false;
    } else if (spacing < 2) {
      _markEvery = 30;
      _labelEvery = 30;
      _largeMarkerInterval = 60 * 5;
      _showSeconds = true;
    } else if (spacing < 4) {
      _markEvery = 15;
      _labelEvery = 15;
      _largeMarkerInterval = 60 * 5;
      _showSeconds = true;
    } else if (spacing < 8) {
      _markEvery = 10;
      _labelEvery = 10;
      _largeMarkerInterval = 60;
      _showSeconds = true;
    } else if (spacing < 16) {
      _markEvery = 5;
      _labelEvery = 5;
      _largeMarkerInterval = 60;
      _showSeconds = true;
    } else if (spacing < 32) {
      _markEvery = 2;
      _labelEvery = 2;
      _largeMarkerInterval = 15;
      _showSeconds = true;
    } else {
      _markEvery = 1;
      _labelEvery = 1;
      _largeMarkerInterval = 15;
      _showSeconds = true;
    }

    performLayout();
  }
  double getLeftForTime(int arg_position) {
    return (arg_position - start) * spacing;
  }

  int getTimeForLeft(int arg_left) {
    if (spacing != 0) {
      return (arg_left ~/ spacing) + start;
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

  void deleteSelSched() {
    if (_list.selected.length != 0) {
      int first = _list.selected.first;
      if (first < data.length) {
        data.removeAt(first);
      }
    }
  }

  void editSelSched() {
    //TODO: implement
  }
}
