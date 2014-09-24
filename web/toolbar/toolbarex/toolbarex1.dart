library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/dockable.dart';

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    ToolBar toolbar = querySelector(".toolbar1");
    //toolbar.items().add(new DivElement());
    //toolbar.items().removeAt(1);
    ToolbarIconItem item1 = new Element.tag("toolbar-icon-item");
    item1.src = "../../resources/icons/star/24x24.png";
    toolbar.insertItem(1, item1);
    item1.togglable = true;
    item1.checked = true;

    //toolbar.removeItem(toolbar.items.first);
  });
}