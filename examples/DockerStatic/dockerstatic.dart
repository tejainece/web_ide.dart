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
    
    /*
    //IDE arrangement
    DockableContainer editorC = new Element.tag('dockable-container');
    editorC.ContainerName = "editor";
    DockableContainer fileC = new Element.tag('dockable-container');
    fileC.ContainerName = "file";
    DockableContainer propertiesC = new Element.tag('dockable-container');
    propertiesC.ContainerName = "properties";
    DockableContainer consoleC = new Element.tag('dockable-container');
    consoleC.ContainerName = "console";
    
    dm.dockToTop(editorC);
    dm.dockToTop(fileC);
    //fileC.unDockMe();
    dm.dockToLeft(consoleC);*/
    
    //IDE arrangement
    DockableContainer top = new Element.tag('dockable-container');
    top.style.backgroundColor = 'red';
    top.ContainerName = "top";
    DockableContainer v1 = new Element.tag('dockable-container');
    v1.style.backgroundColor = 'blue';
    v1.ContainerName = "v1";
    DockableContainer v2 = new Element.tag('dockable-container');
    v2.style.backgroundColor = 'orange';
    v2.ContainerName = "v2";
    DockableContainer v3 = new Element.tag('dockable-container');
    v3.style.backgroundColor = 'green';
    v3.ContainerName = "v3";
    DockableContainer v4 = new Element.tag('dockable-container');
    v4.style.backgroundColor = 'green';
    v4.ContainerName = "v4";
    DockableContainer v5 = new Element.tag('dockable-container');
    v5.style.backgroundColor = 'green';
    v5.ContainerName = "v5";
    DockableContainer v6 = new Element.tag('dockable-container');
    v6.style.backgroundColor = 'green';
    v6.ContainerName = "v6";
    DockableContainer h1 = new Element.tag('dockable-container');
    h1.style.backgroundColor = 'black';
    h1.ContainerName = "h1";
    DockableContainer h2 = new Element.tag('dockable-container');
    h2.style.backgroundColor = 'white';
    h2.ContainerName = "h2";
    DockableContainer h3 = new Element.tag('dockable-container');
    h3.style.backgroundColor = 'gray';
    h3.ContainerName = "h3";
    DockableContainer h4 = new Element.tag('dockable-container');
    h4.style.backgroundColor = 'gray';
    h4.ContainerName = "h4";
    DockableContainer h5 = new Element.tag('dockable-container');
    h5.style.backgroundColor = 'gray';
    h5.ContainerName = "h5";
    DockableContainer h6 = new Element.tag('dockable-container');
    h6.style.backgroundColor = 'gray';
    h6.ContainerName = "h6";
    
    //test dockToTop, dockToTop(, topOf first container)
    // , dockToTop(, topOf middle container)
    // , dockToTop(, topOf last container)
    /*dm.dockToTop(top);
    top.dockToTop(v1);
    top.dockToTop(v2);
    top.dockToTop(v3);
    top.dockToTop(v4, v2);
    top.dockToTop(v5, v1);
    top.dockToTop(v6, v3);*/
    
    //test dockToBottom, dockToBottom(, bottomOf first container)
    // , dockToBottom(, bottomOf middle container)
    // , dockToBottom(, bottomOf last container)
    /*dm.dockToBottom(top);
    top.dockToBottom(v1);
    top.dockToBottom(v2);
    top.dockToBottom(v3);
    top.dockToBottom(v4, v2);
    top.dockToBottom(v5, v1);
    top.dockToBottom(v6, v3);*/
    
    //test dockToLeft, dockToLeft(, leftOf first container)
    // , dockToLeft(, leftOf middle container)
    // , dockToLeft(, leftOf last container)
    /*dm.dockToLeft(top);
    top.dockToLeft(h1);
    top.dockToLeft(h2);
    top.dockToLeft(h3);
    top.dockToLeft(h4, h2);
    top.dockToLeft(h5, h1);
    top.dockToLeft(h6, h3);*/
    
    //test dockToRight, dockToRight(, rightOf first container)
    // , dockToRight(, rightOf middle container)
    // , dockToRight(, rightOf last container)
    /*dm.dockToRight(top);
    top.dockToRight(h1);
    top.dockToRight(h2);
    top.dockToRight(h3);
    top.dockToRight(h4, h2);
    top.dockToRight(h5, h1);
    top.dockToRight(h6, h3);*/
    
    //test dockToBottom splitter slide
    dm.dockToBottom(top);
    top.dockToBottom(v1);
    top.dockToBottom(v2);
    top.dockToBottom(v3, v1);
    
    //dm.dockToTop(top);
    //top.dockToTop(v1);
    //top.dockToTop(v2);
    //top.dockToTop(v3);
    //top.dockToLeft(h1, v2);
    
    //dm.dockToTop(top);
    //top.dockToLeft(v1);
    //top.dockToLeft(v2);
    //top.dockToLeft(v3);
    //top.dockToTop(h1, v2);
    
    //dm.dockToTop(top);
    //dm.dockToLeft(h1);
    //dm.dockToRight(h2);
    //dm.dockToTop(v1);
    //dm.dockToBottom(v2);
    
    /*
    //Array of one type 
    for(int i = 0; i < 6; i++) {
      DockableContainer nDC = new Element.tag('dockable-container');
      nDC.ContainerName = "${i + 1}";
      if(dm.dockToTop(nDC)) {
        print("Wow docked left! ${i + 1}");
        conatiners.add(nDC);
      } else {
        print("Couldn't dock! ${i + 1}");
      }
    }*/
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