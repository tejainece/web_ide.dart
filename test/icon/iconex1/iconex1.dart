library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/icon/dockable_icon.dart';

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {    
    DockableIcon ic1 = new Element.tag("dockable-icon");
    ic1.src = "../icons/windowadd32x32.png";
    ic1.size = 32;
    document.body.children.add(ic1);
    
    DockableIcon ic2 = new Element.tag("dockable-icon");
    ic2.src = "../../asset/icons/star24.png";
    ic2.size = 24;
    document.body.children.add(ic2);
  });
}