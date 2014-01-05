library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/modal/modal.dart';

List<DockableModal> tabs = new List<DockableModal>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {    
    for(int i = 0; i < 3; i++) {
      DockableModal mod = new Element.tag('dockable-modal');
      document.body.children.add(mod);
    }
  });
  
  querySelector("#add_modal").onClick.listen((e) {
  });
  
  querySelector("#rm_cur_modal").onClick.listen((e) {
    
  });
}