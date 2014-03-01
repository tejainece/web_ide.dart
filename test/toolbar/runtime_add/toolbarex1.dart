library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {   
    DockableToolbar tb = document.querySelector('.toolbar1');
    ToolbarIconItem ic1 = new Element.tag('dockable-toolbar-icon-item');
    ic1.src = "../icons/star24x24.png";
    ic1.size = 24;
    ic1.togglable = true;
    tb.addItem(ic1);
    
    ToolbarSeparater sp1 = new Element.tag('dockable-toolbar-separater-item');
    sp1.size = 2;
    tb.addItem(sp1);
    
    ToolbarIconItem ic2 = new Element.tag('dockable-toolbar-icon-item');
    ic2.src = "../icons/windowadd32x32.png";
    ic2.size = 24;
    ic2.togglable = false;
    tb.addItem(ic2);
    /*DockableIcon ic1 = new Element.tag("dockable-icon");
    ic1.src = "../icons/windowadd32x32.png";
    ic1.size = 32;
    document.body.children.add(ic1);
    
    DockableIcon ic2 = new Element.tag("dockable-icon");
    ic2.src = "../icons/star24x24.png";
    ic2.size = 24;
    document.body.children.add(ic2);*/
  });
}