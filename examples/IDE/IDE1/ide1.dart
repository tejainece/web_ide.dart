library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/docker/dock_manager.dart';
import 'package:dockable/toolbar/toolbar.dart';
import 'package:dockable/menubar/menubar.dart';

num count = 0; //TODO: remove

/// create dock area
DockManager buildDockArea() {
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

DockableToolbar buildToolbar() {
  DockableToolbar tb = new Element.tag('dockable-toolbar');
  tb.size = 24;
  
  ToolbarIconItem ic1 = new Element.tag('dockable-toolbar-icon-item');
  ic1.src = "../../resources/icons/star/24x24.png";
  ic1.size = 24;
  ic1.togglable = true;
  tb.addItem(ic1);
  
  ToolbarSeparater sp1 = new Element.tag('dockable-toolbar-separater-item');
  sp1.size = 2;
  tb.addItem(sp1);
  
  ToolbarIconItem ic2 = new Element.tag('dockable-toolbar-icon-item');
  ic2.src = "../../resources/icons/windowadd/32x32.png";
  ic2.size = 24;
  ic2.togglable = false;
  tb.addItem(ic2);
  
  return tb;
}

Menubar buildMenubar() {
  Menubar mb = new Element.tag('menu-bar');
  
  MenuItem menu1 = new Element.tag('menu-item')
    ..title = "Menu1";
  mb.addMenu(menu1);
  
  MenuItem menu2 = new Element.tag('menu-item')
  ..title = "Menu2";
  mb.addMenu(menu2);
  
  MenuItem menu3 = new Element.tag('menu-item')
  ..title = "Menu3";
  mb.addMenu(menu3);
  
  return mb;
}

List<DockableContainer> conatiners = new List<DockableContainer>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    DockableToolbar toolBar = buildToolbar();
    toolBar.id = "toolbar";
    mc.children.add(toolBar);
    
    DockManager dockM = buildDockArea();
    dockM.id = "dock";
    mc.children.add(dockM);
  });
}