library icon;

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
@CustomTag('dockable-icon')
class DockableIcon extends PolymerElement {
  DockableIcon.created() : super.created() {
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
  @published int size = 24;
      
  @override 
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }
  
  @override
  void ready() {
    super.ready();
    this.sizeChanged();
  }
    
  void sizeChanged() {    
    this.style.width =  '${this.size}px';
    this.style.height = '${this.size}px';
    this.style.backgroundSize = '${this.size}px ${this.size}px';
  }
  
  void srcChanged() {
    _logger.finest('srcChanged');
    this.style.backgroundImage = 'url(' + this.src + ')';
    this.style.backgroundPosition = 'center';
    this.style.backgroundSize = '${this.size}px ${this.size}px';
  }
}
