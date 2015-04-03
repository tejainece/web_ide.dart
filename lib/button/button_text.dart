@HtmlImport('button_text.html')
library icon;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

/**
 * icon-view is a 24x24 glyph expressed as a background-image.
 *
 * Example:
 *
 *     <icon-view src="star.png"></icon-view>
 *
 * Optionally can use other size like 32x32 by setting the attributes "width" and "height" to "32":
 *
 *     <icon-view src="big_star.png" width=32 height=32></icon-view>
 *
 * @class icon-view
 */
@CustomTag('button-text')
class ButtonText extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  ButtonText.created() : super.created() {
  }

  /**
   * The URL of an image for the icon.
   */
  @published
  String label = '';

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
  }
}
