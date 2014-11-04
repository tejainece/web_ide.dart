library colorpicker;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';
import 'dart:math';

import '../utils/dockable_utils.dart';

import "package:paper_elements/paper_slider.dart";

part 'hsv_picker.dart';
part 'hue_slider.dart';
part 'alpha_slider.dart';

/*
 * TODO:
 * 1) test size change
 */

@CustomTag('color-picker')
class ColorPicker extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  /*HsvPicker _hsv_gradient;
  HueSlider _hue_slider;

  PaperSlider _alphaSlider;*/

  ColorPicker.created() : super.created() {
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    /*_hsv_gradient = shadowRoot.querySelector(".hsv-picker");

    _hue_slider = shadowRoot.querySelector(".hue-slider");

    _alphaSlider = shadowRoot.querySelector("#alpha-slider");*/
    //sizeChanged();
    
    this.onContextMenu.listen((ev) {
      //TODO: ev.preventDefault();
    });
  }

  @PublishedProperty(reflect: true)
  int size = 100;

  void sizeChanged() {
    this.style.width = "${size+5+16}px";
    this.style.height = "${size}px";
  }

  @PublishedProperty(reflect: true)
  ColorVal color = new ColorVal();

  void colorChanged() {
    if (_colChgStream != null) {
      _colChgStream.cancel();
      _colChgStream = null;
    }

    if (color != null) {
      _colChgStream = color.changes.listen((_) {
        _fire_onchanged_event();
      });
    } else {

    }

    _fire_onchanged_event();
  }

  StreamSubscription _colChgStream;

  void _fire_onchanged_event() {
    //TODO: send valid detail
    var event = new CustomEvent("changed", canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }

  //events
  EventStreamProvider<CustomEvent> _changedEventP = new EventStreamProvider<CustomEvent>("changed");
  Stream<CustomEvent> get onChanged => _changedEventP.forTarget(this);
}
