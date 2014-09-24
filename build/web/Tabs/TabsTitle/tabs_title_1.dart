library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

num count = 0; //TODO: remove

TabTitle tt;
List<TabTitleItem> conatiners = new List<TabTitleItem>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    tt = new Element.tag('tab-title');
    tt.id = "dm";
    mc.children.add(tt);
    
    TabTitleItem tti1 = new Element.tag('tab-title-item');
    
    TabTitleItem tti2 = new Element.tag('tab-title-item');
    
    TabTitleItem tti3 = new Element.tag('tab-title-item');
    
    tt.addItem(tti1);
    tt.addItem(tti2);
    tt.addItem(tti3);
    tti1.setTitle('1');
    tti2.setTitle('2');
    tti3.setTitle('3');
  });
  querySelector("#new_left").onClick.listen((e) {
    
  });
  
  querySelector("#new_top").onClick.listen((e) {
    
  });
  querySelector("#undock").onClick.listen((e) {
  });
}