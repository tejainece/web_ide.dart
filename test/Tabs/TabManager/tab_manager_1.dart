library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

TabManager tm;
List<TabItem> tabs = new List<TabItem>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    tm = new Element.tag('tab-manager');
    tm.id = "dm";
    mc.children.add(tm);

    for(int i = 0; i < 3; i++) {
      DivElement content = new DivElement();
      content.text = "Tab${i} data";
      TabItem ti = new TabItem(content, "Tab${i}");
      tm.addItem(ti);
      tabs.add(ti);
    }
  });

  querySelector("#add_page").onClick.listen((e) {
    TabItem ti = new TabItem(null, null);
    tm.addItem(ti);
    tabs.add(ti);
  });

  querySelector("#rm_cur_page").onClick.listen((e) {

  });
}