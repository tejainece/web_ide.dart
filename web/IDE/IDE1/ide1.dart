library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

/// create dock area
DockManager buildDockArea() {
  DockManager dm = new Element.tag('dock-manager');
  DockContainer editorC = new Element.tag('dock-container');
  DockContainer fileC = new Element.tag('dock-container');
  DockContainer propertiesC = new Element.tag('dock-container');
  DockContainer consoleC = new Element.tag('dock-container');

  dm.dockToTop(editorC);
  dm.dockToBottom(consoleC);
  dm.dockToLeft(fileC);
  dm.dockToRight(propertiesC);


  return dm;
}

ToolBar buildToolbar() {
  ToolBar tb = new Element.tag('tool-bar');
  tb.size = 24;

  ToolbarIconItem ic1 = new Element.tag('toolbar-icon-item');
  ic1.src = "../../resources/icons/star/24x24.png";
  ic1.togglable = true;
  tb.addItem(ic1);

  ToolbarSeparater sp1 = new Element.tag('toolbar-separater-item');
  tb.addItem(sp1);

  ToolbarIconItem ic2 = new Element.tag('toolbar-icon-item');
  ic2.src = "../../resources/icons/windowadd/32x32.png";
  ic2.togglable = false;
  tb.addItem(ic2);

  return tb;
}

Menubar buildMenubar() {
  Menubar mb = new Element.tag('menu-bar');

  MenuItem menu1 = new Element.tag('menu-item');
  menu1.heading = "Menu1";
  mb.addMenu(menu1);

  MenuItem menu2 = new Element.tag('menu-item');
  menu2.heading = "Menu2";
  mb.addMenu(menu2);

  MenuItem menu3 = new Element.tag('menu-item');
  menu3.heading = "Menu3";
  mb.addMenu(menu3);

  return mb;
}

List<DockContainer> conatiners = new List<DockContainer>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    ToolBar toolBar = buildToolbar();
    toolBar.id = "toolbar";
    mc.children.add(toolBar);

    DockManager dockM = buildDockArea();
    dockM.id = "dock";
    mc.children.add(dockM);
  });
}