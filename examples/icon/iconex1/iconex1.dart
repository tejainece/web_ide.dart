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
  });
}