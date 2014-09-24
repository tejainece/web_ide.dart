library icon;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';
import 'dart:math';

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
@CustomTag('icon-view')
class IconView extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  IconView.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('PolymerUiIcon');

  /**
   * The URL of an image for the icon.
   */
  @published String src = '';

  /**
   * Specifies the size of the icon.
   */
  @published int width = 24;
  @published int height = 24;

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
    this.widthChanged();
    this.heightChanged();
    srcChanged();
  }

  void widthChanged() {
  }
  void heightChanged() {
  }

  void srcChanged() {
    this.style.backgroundImage = 'url(' + this.src + ')';
  }
}
