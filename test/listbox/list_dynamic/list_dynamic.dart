library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    ListBox lbox = new Element.tag("list-box");
    mc.children.add(lbox);

    ListItem item1 = new Element.tag("list-item");
    item1.label = "item1";
    /*item1.onClick.listen((_) {
      item1.select();
    });*/
    lbox.addItem(item1);

    ListItem item2 = new Element.tag("list-item");
    item2.label = "item2";
    /*item2.onClick.listen((_) {
      item2.select();
    });*/
    lbox.addItem(item2);

    lbox.itemheight = 30;
  });
}