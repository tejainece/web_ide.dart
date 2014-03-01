library colorpicker;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

/**
 * dockable-icon is a 24x24 glyph expressed as a background-image.
 *
 * Example:
 *
 *     <dockable-icon src="star.png"></dockable-icon>
 *
 * Optionally can use other size like 32x32 by setting the attribute "size" to "32":
 *
 *     <dockable-icon src="big_star.png" size="32"></dockable-icon>
 *
 * @class dockable-icon
 */
@CustomTag('color-picker')
class ColorPicker extends PolymerElement {
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
  }
}
