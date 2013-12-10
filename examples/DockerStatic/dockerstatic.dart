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
    
    for(int i = 0; i < 6; i++) {
      DockableContainer nDC = new Element.tag('dockable-container');
      nDC.ContainerName = "${i}";
      if(dm.dockToLeft(nDC)) {
        print("Wow docked left! ${i}");
        conatiners.add(nDC);
      } else {
        print("Couldn't dock! ${i}");
      }
    }
  });
  querySelector("#new_left").onClick.listen((e) {
    
  });
  
  querySelector("#new_top").onClick.listen((e) {
    
  });
  querySelector("#undock").onClick.listen((e) {
    if(dm != null) {
      conatiners.last.unDockMe();
      conatiners.removeLast();
    }
  });
}