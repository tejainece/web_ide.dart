library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/docker/dock_manager.dart';

num count = 0; //TODO: remove

DockManager dm;
List<DockableContainer> conatiners = new List<DockableContainer>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    dm = new Element.tag('dock-manager');
    dm.id = "dm";
    mc.children.add(dm);
  });
  querySelector("#new_left").onClick.listen((e) {
    if(dm != null) {
      count++;
      
      DockableContainer nDC = new Element.tag('dockable-container');
      //nDC.style.backgroundColor = "green";
      if(dm.dockToLeft(nDC)) {
        print("Wow docked left!");
        conatiners.add(nDC);
      } else {
        print("Couldn't dock!");
      }
    }
  });
  
  querySelector("#new_top").onClick.listen((e) {
    if(dm != null) {
      count++;
      
      DockableContainer nDC = new Element.tag('dockable-container');
      //nDC.style.backgroundColor = "green";
      if(dm.dockToTop(nDC)) {
        print("Wow docked top!");
        conatiners.add(nDC);
      } else {
        print("Couldn't dock!");
      }
    }
  });
  querySelector("#undock").onClick.listen((e) {
    if(dm != null) {
      conatiners.last.unDockMe();
      conatiners.removeLast();
    }
  });
}