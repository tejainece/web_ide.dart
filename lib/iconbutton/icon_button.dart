library iconbutton;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

/*
 * TODO:
 * 1) Two modes: Toggle mode and Click mode
 * 2) onClick() stream
 * 3) onSelect() stream
 *
 * Show border on mouse over
 */

/**
 * icon-button enables you to place an image centered in a button.
 *
 * Example:
 *
 *     <icon-button src="star.png"></icon-button>
 *
 * @class dockable-icon-button
 */
@CustomTag('icon-button')
class IconButton extends PolymerElement {
  IconButton.created() : super.created();

  @override
  void polymerCreated() {
    super.polymerCreated();
    sizeChanged();

    onClick.listen((e) {
      if(togglable) {
        toggleSelection();
      }
    });
  }

  /**
   * The URL of an image for the icon.
   */
  @published String src = '';

  /**
   * The size of the icon button.
   */
  @published int size = 24;
  @published num ICON_SIZE = 0.8;
  @published num PADDING_SIZE = 0.1;

  void sizeChanged() {
    this.style.width =  '${this.size}px';
    this.style.height = '${this.size}px';

    //this.style.padding = '${this.size }px ${this.size}px';
  }

  /**
   * Sets if the icon button is togglable
   */
  @published bool togglable = false;

  void togglableChange() {
    //TODO: debug to see if the value of toggable is updated?
    print('${togglable}');
    if(togglable) {

    } else {
      deselect();
    }
  }

  /**
   * If true, border is placed around the button to indicate
   * active state.
   */
  bool _selected = false;
  bool get selected => _selected;
  select() {
    if(togglable && _selected != true) {
      _selected = true;
      //TODO: send valid detail
      var event = new CustomEvent("selected",
                canBubble: false, cancelable: false, detail: null);
      dispatchEvent(event);
      this.classes.add('active');
    }
  }
  deselect() {
    if(togglable && _selected != false) {
      _selected = false;
      //TODO: send valid detail
      var event = new CustomEvent("deselected",
                canBubble: false, cancelable: false, detail: null);
      dispatchEvent(event);
      this.classes.remove('active');
    }
  }
  toggleSelection() {
    if(_selected) {
      deselect();
    } else {
      select();
    }
  }

  //events
  EventStreamProvider<CustomEvent> _selectedEventP = new EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected =>
        _selectedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _deselectedEventP = new EventStreamProvider<CustomEvent>("deselected");
  Stream<CustomEvent> get onDeselected =>
        _deselectedEventP.forTarget(this);
}
