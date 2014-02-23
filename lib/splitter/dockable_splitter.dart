part of dockable;

class DockableSplitterSlideEvent {
  DockableSplitter target;
  int delta;
  int offsetPos;
  int clientPos;
  bool horizontal;
}

@CustomTag('dockable-splitter')
class DockableSplitter extends PolymerElement {
  /*bool _vertical = false;
  bool get vertical => _vertical;
  set vertical(bool _v) {
    setAttribute('vertical', _v ? 'true' : 'false');
  }*/
  @published bool vertical;
  @published bool locked;

  /// Temporary subsciptions to event streams, active only during dragging.
  StreamSubscription<MouseEvent> _trackSubscr;
  StreamSubscription<MouseEvent> _trackEndSubscr;

  /// Constructor.
  DockableSplitter.created() : super.created() {
    onMouseDown.listen(trackStart);
    if(vertical == null) {
      vertical = false;
    }
    if(locked == null) {
      locked = false;
    }
  }

  /// Triggered when [vertical] is externally changed.
  void verticalChanged() {
    if(vertical == true) {
      classes.add('vertical');
    } else if(vertical == false) {
      classes.remove('vertical');
    } else {
      vertical = false;
    }
  }

  /// When dragging starts, cache the target's size and temporarily subscribe
  /// to necessary events to track dragging.
  void trackStart(MouseEvent e) {
    // Make active regardless of [locked], to appear responsive.
    classes.add('active');

    if (!locked) {
      // To avoid sticky dragging state
      _trackSubscr = document.onMouseMove.listen(track);
      _trackEndSubscr = document.onMouseUp.listen(trackEnd);
    }
  }

  /// While dragging, update the target's size based on the mouse movement.
  void track(MouseEvent e) {
    // Recheck [locked], in case it's been changed externally in mid-flight.
    if (!locked) {
      DockableSplitterSlideEvent event = new DockableSplitterSlideEvent();
      event.delta = vertical ? e.movement.y : e.movement.x;
      event.offsetPos = vertical ? e.offset.y : e.offset.x;
      event.clientPos = vertical ? e.client.y : e.client.x;
      event.horizontal = vertical;
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
  
  /*void attributeChanged(String name, String oldValue, String newValue) {
    /* code to set vertical correctly*/
    if(name == 'vertical') {
      if(newValue == 'false') {
        _vertical = false;
      } else if (newValue == 'true') {
        _vertical = true;
      }
      verticalChanged();
    }
    super.attributeChanged(name, oldValue, newValue);
  }*/
  
  //events
  StreamController _slideEventController = new StreamController.broadcast();
  
  Stream get onSlide => _slideEventController.stream;
}