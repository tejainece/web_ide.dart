library iconbutton;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

import "../menubar/menubar.dart";

part 'icon_list_button.dart';
part 'icon_options_button.dart';

/**
 * icon-button enables you to place an image centered in a button.
 *
 * Example:
 *
 *     <icon-button src="star.png"></icon-button>
 *
 * @class icon-button
 */
@CustomTag('icon-button')
class IconButton extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  IconButton.created(): super.created();

  @override
  void polymerCreated() {
    super.polymerCreated();
    widthChanged();
    heightChanged();

    onClick.listen((e) {
      if (togglable) {
        toggleSelection();
      }
    });
  }

  /**
   * The URL of an image for the icon.
   */
  @published
  String src = '';

  /**
   * The size of the icon button.
   */
  @published
  int width = 24;
  @published
  int height = 24;
  @observable
  num get ICON_SIZE => 0.8;
  @observable
  num get PADDING_SIZE => 0.1;

  void widthChanged() {
  }
  void heightChanged() {
  }

  /**
   * Sets if the icon button is togglable
   */
  @published
  bool togglable = false;

  void togglableChanged() {
    //TODO: debug to see if the value of toggable is updated?
    if (!togglable) {
      checked = false;
    }
  }

  /**
   * If true, border is placed around the button to indicate
   * active state.
   */
  @published
  bool checked = false;

  void checkedChanged() {
    if (togglable) {
      if (checked) {
        var event = new CustomEvent("changed", canBubble: false, cancelable:
            false, detail: true);
        dispatchEvent(event);
        classes.add('checked');
      } else {
        var event = new CustomEvent("changed", canBubble: false, cancelable:
            false, detail: false);
        dispatchEvent(event);
        classes.remove('checked');
      }
    } else {
      if (checked) {
        checked = false;
      }
    }
  }

  toggleSelection() {
    if (togglable) {
      checked = !checked;
    } else {
      if (checked) {
        checked = false;
      }
    }
  }

  //events
  EventStreamProvider<CustomEvent> _changedEventP =
      new EventStreamProvider<CustomEvent>("changed");
  Stream<CustomEvent> get onChanged => _changedEventP.forTarget(this);
}
