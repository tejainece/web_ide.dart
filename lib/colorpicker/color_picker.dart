library colorpicker;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';
import 'dart:math';

import '../utils/dockable_utils.dart';

part 'hsv_picker.dart';
part 'hue_slider.dart';

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

  @published int red = 255;
  @published int blue = 255;
  @published int green = 255;

  HsvPicker _hsv_gradient;
  HueSlider _hue_slider;

  ColorPicker.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Dockable.ColorPicker');

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _hsv_gradient = shadowRoot.querySelector(".hsv-picker");
    assert(_hsv_gradient != null);

    _hue_slider = shadowRoot.querySelector(".hue-slider");
    assert(_hue_slider != null);

    _hue_slider.onChanged.listen((_) {
      _hsv_gradient.hue = _hue_slider.hue;
    });

    _hsv_gradient.onChanged.listen((_) {
      if(_hsv_gradient.color != _color) {
        _color = _hsv_gradient.color;
        _fire_onchanged_event();
      }
    });

    //sizeChanged();
  }

  @published
  int size = 100;

  void sizeChanged() {
    this.style.width = "${size+5+16}px";
    this.style.height = "${size}px";
  }

  ColorVal _color = new ColorVal.fromRGB(255, 255, 255);
  ColorVal get color => _color;

  set color(ColorVal arg_color) {
    if(arg_color != null && arg_color != _color) {
      _color = arg_color;
      _hsv_gradient.color = _color;
      _hue_slider.hue = _color.h;
    }
  }

  void _fire_onchanged_event() {
    //TODO: send valid detail
    var event = new CustomEvent("changed",
            canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }

  //events
  EventStreamProvider<CustomEvent> _changedEventP = new EventStreamProvider<CustomEvent>("changed");
  Stream<CustomEvent> get onChanged =>
      _changedEventP.forTarget(this);
}
