library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../lib/dock/dockable_manager.dart';
import '../../lib/container/dockable_container.dart';

num count = 0; //TODO: remove

DockableManager dm;
List<DockableContainer> conatiners = new List<DockableContainer>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    dm = new Element.tag('dockable-manager');
    dm.id = "dm";
    mc.children.add(dm);
  });
  querySelector("#new_left").onClick.listen((e) {
    if(dm != null) {
      count++;
      
      DockableContainer nDC = new Element.tag('dockable-container');
      //nDC.style.backgroundColor = "green";
      nDC.ContainerName = "${count++}";
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
      nDC.ContainerName = "${count++}";
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