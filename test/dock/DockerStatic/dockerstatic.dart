library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/docker/dock_manager.dart';

num count = 0; //TODO: remove

///test dockToLeft
DockManager testDockLeft() {
  DockManager dm = new Element.tag('dock-manager');
  
  DockableContainer top = new Element.tag('dockable-container');
  top.style.backgroundColor = 'red';
  DockableContainer c1 = new Element.tag('dockable-container');
  c1.style.backgroundColor = 'blue';
  DockableContainer c2 = new Element.tag('dockable-container');
  c2.style.backgroundColor = 'orange';
  DockableContainer c3 = new Element.tag('dockable-container');
  c3.style.backgroundColor = 'green';
  DockableContainer c4 = new Element.tag('dockable-container');
  c4.style.backgroundColor = 'gray';
  
  dm.dockToLeft(top);
  top.dockToLeft(c1);
  top.dockToLeft(c2);
  top.dockToLeft(c3);
  top.dockToLeft(c4);
  
  return dm;
}

///test dockToLeft
DockManager testDockLeftTo() {
  DockManager dm = new Element.tag('dock-manager');
  
  DockableContainer top = new Element.tag('dockable-container');
  top.style.backgroundColor = 'red';
  DockableContainer c1 = new Element.tag('dockable-container');
  c1.style.backgroundColor = 'blue';
  DockableContainer c2 = new Element.tag('dockable-container');
  c2.style.backgroundColor = 'orange';
  DockableContainer c3 = new Element.tag('dockable-container');
  c3.style.backgroundColor = 'green';
  DockableContainer c4 = new Element.tag('dockable-container');
  c4.style.backgroundColor = 'green';
  
  dm.dockToLeft(top);
  top.dockToLeft(c1);
  top.dockToLeft(c2);
  top.dockToLeft(c3);
  top.dockToLeft(c4, c1);
  
  return dm;
}

///test dockToRight
DockManager testDockRight() {
  DockManager dm = new Element.tag('dock-manager');
  
  DockableContainer top = new Element.tag('dockable-container');
  top.style.backgroundColor = 'red';
  DockableContainer c1 = new Element.tag('dockable-container');
  c1.style.backgroundColor = 'blue';
  DockableContainer c2 = new Element.tag('dockable-container');
  c2.style.backgroundColor = 'orange';
  DockableContainer c3 = new Element.tag('dockable-container');
  c3.style.backgroundColor = 'green';
  DockableContainer c4 = new Element.tag('dockable-container');
  c4.style.backgroundColor = 'gray';
  
  dm.dockToRight(top);
  top.dockToRight(c1);
  top.dockToRight(c2);
  top.dockToRight(c3);
  top.dockToRight(c4);
  
  return dm;
}

///test dockToRight
DockManager testDockRightTo() {
  DockManager dm = new Element.tag('dock-manager');
  
  DockableContainer top = new Element.tag('dockable-container');
  top.style.backgroundColor = 'red';
  DockableContainer c1 = new Element.tag('dockable-container');
  c1.style.backgroundColor = 'blue';
  DockableContainer c2 = new Element.tag('dockable-container');
  c2.style.backgroundColor = 'orange';
  DockableContainer c3 = new Element.tag('dockable-container');
  c3.style.backgroundColor = 'green';
  DockableContainer c4 = new Element.tag('dockable-container');
  c4.style.backgroundColor = 'gray';
  
  dm.dockToRight(top);
  top.dockToRight(c1);
  top.dockToRight(c2);
  top.dockToRight(c3);
  top.dockToRight(c4, c2);
  
  return dm;
}

///test dockToTop
DockManager testDockTop() {
  DockManager dm = new Element.tag('dock-manager');
  
  DockableContainer top = new Element.tag('dockable-container');
  top.style.backgroundColor = 'red';
  DockableContainer c1 = new Element.tag('dockable-container');
  c1.style.backgroundColor = 'blue';
  DockableContainer c2 = new Element.tag('dockable-container');
  c2.style.backgroundColor = 'orange';
  DockableContainer c3 = new Element.tag('dockable-container');
  c3.style.backgroundColor = 'green';
  DockableContainer c4 = new Element.tag('dockable-container');
  c4.style.backgroundColor = 'gray';
  
  dm.dockToTop(top);
  top.dockToTop(c1);
  top.dockToTop(c2);
  top.dockToTop(c3);
  top.dockToTop(c4);
  
  return dm;
}

///test dockToTop
DockManager testDockTopTo() {
  DockManager dm = new Element.tag('dock-manager');
  
  DockableContainer top = new Element.tag('dockable-container');
  top.style.backgroundColor = 'red';
  DockableContainer c1 = new Element.tag('dockable-container');
  c1.style.backgroundColor = 'blue';
  DockableContainer c2 = new Element.tag('dockable-container');
  c2.style.backgroundColor = 'orange';
  DockableContainer c3 = new Element.tag('dockable-container');
  c3.style.backgroundColor = 'green';
  DockableContainer c4 = new Element.tag('dockable-container');
  c4.style.backgroundColor = 'gray';
  
  dm.dockToTop(top);
  top.dockToTop(c1);
  top.dockToTop(c2);
  top.dockToTop(c3);
  top.dockToTop(c4, c2);
  
  return dm;
}

///test dockToBottom
DockManager testDockBottom() {
  DockManager dm = new Element.tag('dock-manager');
  
  DockableContainer top = new Element.tag('dockable-container');
  top.style.backgroundColor = 'red';
  DockableContainer c1 = new Element.tag('dockable-container');
  c1.style.backgroundColor = 'blue';
  DockableContainer c2 = new Element.tag('dockable-container');
  c2.style.backgroundColor = 'orange';
  DockableContainer c3 = new Element.tag('dockable-container');
  c3.style.backgroundColor = 'green';
  DockableContainer c4 = new Element.tag('dockable-container');
  c4.style.backgroundColor = 'gray';
  
  dm.dockToBottom(top);
  top.dockToBottom(c1);
  top.dockToBottom(c2);
  top.dockToBottom(c3);
  top.dockToBottom(c4);
  
  return dm;
}

///test dockToBottom
DockManager testDockBottomTo() {
  DockManager dm = new Element.tag('dock-manager');
  
  DockableContainer top = new Element.tag('dockable-container');
  top.style.backgroundColor = 'red';
  DockableContainer c1 = new Element.tag('dockable-container');
  c1.style.backgroundColor = 'blue';
  DockableContainer c2 = new Element.tag('dockable-container');
  c2.style.backgroundColor = 'orange';
  DockableContainer c3 = new Element.tag('dockable-container');
  c3.style.backgroundColor = 'green';
  DockableContainer c4 = new Element.tag('dockable-container');
  c4.style.backgroundColor = 'gray';
  
  dm.dockToBottom(top);
  top.dockToBottom(c1);
  top.dockToBottom(c2);
  top.dockToBottom(c3);
  top.dockToBottom(c4, c1);
  
  return dm;
}

DockManager testDockArrangement1() {
  DockManager dm = new Element.tag('dock-manager');
  DockableContainer editorC = new Element.tag('dockable-container');
  DockableContainer fileC = new Element.tag('dockable-container');
  DockableContainer propertiesC = new Element.tag('dockable-container');
  DockableContainer consoleC = new Element.tag('dockable-container');
  
  dm.dockToTop(editorC);
  dm.dockToLeft(fileC);
  dm.dockToRight(propertiesC);
  dm.dockToBottom(consoleC);
  
  return dm;
}

List<DockableContainer> conatiners = new List<DockableContainer>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    //TODO: add all the test cases one after the other with heading and description
    DockManager dockM = testDockArrangement1();
    mc.children.add(dockM);
  });
}