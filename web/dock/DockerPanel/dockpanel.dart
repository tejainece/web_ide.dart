library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

DockManager dm;
List<DockContainer> conatiners = new List<DockContainer>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    dm = new Element.tag('dock-manager');
    dm.id = "dm";
    mc.children.add(dm);

    //IDE arrangement
    DockContainer top = new Element.tag('dock-container');
    top.style.backgroundColor = 'red';
    DockContainer v1 = new Element.tag('dock-container');
    v1.style.backgroundColor = 'blue';
    DockContainer v2 = new Element.tag('dock-container');
    v2.style.backgroundColor = 'orange';
    DockContainer v3 = new Element.tag('dock-container');
    v3.style.backgroundColor = 'green';

    DockMultiPanel p1 = new Element.tag('dock-multi-panel');
    DivElement d1 = new DivElement();
    d1.text = "blah blah 1 ";
    //d1.style.height = "100%";
    p1.addPanel(d1, 'my first panel');
    DivElement d2 = new DivElement();
    d2.text = "blah blah 2";
    p1.addPanel(d2, 'my second panel');

    //test dockToBottom splitter slide
    dm.dockToBottom(top);
    dm.dockToLeft(v1);
    dm.dockToRight(v2);
    dm.dockToBottom(v3);
    v3.dockToLeft(p1);
    //top.dockToBottom(p1, v1);
  });
}