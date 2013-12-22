library dockable.splitter;

import 'dart:html';
import 'dart:async';

import 'package:polymer/polymer.dart';

class DockableSplitterSlideEvent {
  DockableSplitter target;
  int delta;
  int offsetPos;
  int clientPos;
  bool horizontal;
}

@CustomTag('dockable-splitter')
class DockableSplitter extends PolymerElement {
  @published bool horizontal = false;
  @published bool locked = false;
  
  /// The target sibling whose size will be changed when the splitter is
  /// dragged. The other sibling is expected to auto-adjust, e.g. using flexbox.
  HtmlElement _target;
  /// Whether [_target] should be the next or the previous sibling of
  /// the splitter (as determined by [direction], e.g. "left" vs. "right").
  bool _isTargetNextSibling;
  /// Cached size of [_target] for the period of dragging.
  int _targetSize;

  /// A regexp to get the integer part of the target's computed size.
  static final _sizeRe = new RegExp("([0-9]+)(\.[0-9]+)?px");

  /// Temporary subsciptions to event streams, active only during dragging.
  StreamSubscription<MouseEvent> _trackSubscr;
  StreamSubscription<MouseEvent> _trackEndSubscr;

  /// Constructor.
  DockableSplitter.created() : super.created() {
    onMouseDown.listen(trackStart);
    horizontalChanged();
  }

  /// Triggered when [horizontal] is externally changed.
  void horizontalChanged() {
    //classes.toggle('horizontal', _isHorizontal);
    if(horizontal) {
      classes.add('horizontal');
    }
  }

/// Cache the current size of the target.
  void _cacheTargetSize() {
    //final style = _target.getComputedStyle();
    //final sizeStr = _isHorizontal ? style.height : style.width;
    //_targetSize = int.parse(_sizeRe.firstMatch(sizeStr).group(1));
  }

  /// When dragging starts, cache the target's size and temporarily subscribe
  /// to necessary events to track dragging.
  void trackStart(MouseEvent e) {
    // Make active regardless of [locked], to appear responsive.
    classes.add('active');

    if (!locked) {
      _cacheTargetSize();
      // NOTE: unlike onMouseDown, monitor onMouseMove and onMouseUp for
      // the entire document; otherwise, once/if the cursor leaves the boundary
      // of our element, the events will stop firing, leaving us in a permanent
      // "sticky" dragging state.
      _trackSubscr = document.onMouseMove.listen(track);
      _trackEndSubscr = document.onMouseUp.listen(trackEnd);
    }
  }

  /// While dragging, update the target's size based on the mouse movement.
  void track(MouseEvent e) {
    // Recheck [locked], in case it's been changed externally in mid-flight.
    if (!locked) {
      DockableSplitterSlideEvent event = new DockableSplitterSlideEvent();
      event.delta = horizontal ? e.movement.y : e.movement.x;
      event.offsetPos = horizontal ? e.offset.y : e.offset.x;
      event.clientPos = horizontal ? e.client.y : e.client.x;
      event.horizontal = horizontal;
      event.target = this;
      _slideEventController.add(event);
    }
  }

  /// When dragging stops, unsubscribe from monitoring dragging events except
  /// the starting one.
  void trackEnd(MouseEvent e) {
    assert(_trackSubscr != null && _trackEndSubscr != null);
    // Do this regardless of [locked]. The only case [locked] can be true here
    // is when it's been changed externally in mid-flight. If it's already true
    // when onMouseDown is fired, these subsciptions (and this event handler!)
    // are not activated in the first place.
    _trackSubscr.cancel();
    _trackSubscr = null;
    _trackEndSubscr.cancel();
    _trackEndSubscr = null;

    classes.remove('active');
  }
  
  void attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
    //loadContent();
  }
  
  //events
  StreamController _slideEventController = new StreamController.broadcast();
  
  Stream get onSlide => _slideEventController.stream;
}