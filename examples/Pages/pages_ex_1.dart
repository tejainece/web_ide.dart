library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/pages/page_manager.dart';

num count = 0; //TODO: remove

PageManager dm;
List<PageItem> conatiners = new List<PageItem>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    dm = new Element.tag('page-manager');
    dm.id = "dm";
    mc.children.add(dm);
    
    List colors = ['red', 'blue', 'green'];
    for(int i = 0; i < 3; i++) {
      PageItem pi = new Element.tag('page-item');
      pi.style.backgroundColor = colors[i];
      pi.text = "fuck you! ${i}";
      dm.addItem(pi);
      conatiners.add(pi);
    }
  });
  querySelector("#page1").onClick.listen((e) {
    dm.select(conatiners[0]);
  });
  
  querySelector("#page2").onClick.listen((e) {
    dm.select(conatiners[1]);
  });
  querySelector("#page3").onClick.listen((e) {
    dm.select(conatiners[2]);
  });
}