library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/dockable.dart';

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    IconView ic1 = new Element.tag("icon-view");
    ic1.src = "../../asset/icons/windowadd32.png";
    ic1.width = 32;
    ic1.height = 32;
    document.body.children.add(ic1);

    IconView ic2 = new Element.tag("icon-view");
    ic2.src = "../../asset/icons/star24.png";
    ic2.width = 24;
    ic2.height = 24;
    document.body.children.add(ic2);
  });
}