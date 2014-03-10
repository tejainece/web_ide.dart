library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

DockManager dm;
List<DockableContainer> conatiners = new List<DockableContainer>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    dm = new Element.tag('dock-manager');
    dm.id = "dm";
    mc.children.add(dm);

    //IDE arrangement
    DockableContainer top = new Element.tag('dockable-container');
    top.style.backgroundColor = 'red';
    DockableContainer v1 = new Element.tag('dockable-container');
    v1.style.backgroundColor = 'blue';
    DockableContainer v2 = new Element.tag('dockable-container');
    v2.style.backgroundColor = 'orange';
    DockableContainer v3 = new Element.tag('dockable-container');
    v3.style.backgroundColor = 'green';

    DockablePanel p1 = new Element.tag('dockable-panel');
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