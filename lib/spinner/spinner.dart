@HtmlImport('spinner.html')
library spinner_elm;

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
@CustomTag('spinner-elm')
class SpinnerElm extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  SpinnerElm.created() : super.created() {
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
    
    _holder = shadowRoot.querySelector("#holder");
  }
  
  @published
  bool loading = false;
  
  @published
  int spacing = 5;
  
  @published
  String color1 = "white";
  
  DivElement _holder;
}
