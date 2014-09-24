library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../lib/dockable.dart';

List<ModalWindow> tabs = new List<ModalWindow>();
main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    for(int i = 0; i < 3; i++) {
      ModalWindow mod = new Element.tag('modal-window');
      mod.heading = "Modal ${i}";
      document.body.children.add(mod);
    }
  });

  querySelector("#add_modal").onClick.listen((e) {
  });

  querySelector("#rm_cur_modal").onClick.listen((e) {

  });
}