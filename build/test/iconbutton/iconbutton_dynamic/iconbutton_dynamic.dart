library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/iconbutton/icon_button.dart';

main() {
  DivElement ic = querySelector('#icon-container');
  initPolymer().run(() {
    IconButton ic1 = new Element.tag("icon-button");
    ic1.src = "../../resources/icons/windowadd/32x32.png";
    ic1.width = 32;
    ic1.height = 32;
    ic.children.add(ic1);

    IconButton ic2 = new Element.tag("icon-button");
    ic2.src = "../../resources/icons/star/24x24.png";
    ic2.width = 32;
    ic2.height = 32;
    ic.children.add(ic2);
  });
}