library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

DockStage ds;

main() {
  initPolymer().run(() {
    ds = new Element.tag("dock-stage");
    ds.classes.add("viewport");
    ds.style.width = "400px";
    ds.style.width = "220px";
    ds.stagewidth = 200;
    ds.stageheight = 200;
    document.body.children.add(ds);

    StageElement se1 = new Element.tag("stage-element");
    se1.left = 20;
    se1.top = 20;
    se1.width = 20;
    se1.height = 20;
    se1.onSelected.listen((CustomEvent event) {
      print("se1 selected!");
    });
    se1.onDeselected.listen((CustomEvent event) {
      print("se1 deselected!");
    });

    ds.addElement(se1);


    StageElement se2 = new Element.tag("stage-element");
    se2.left = 60;
    se2.top = 20;
    se2.width = 20;
    se2.height = 20;
    se2.onSelected.listen((CustomEvent event) {
      print("se2 selected!");
    });
    se2.onDeselected.listen((CustomEvent event) {
      print("se2 deselected!");
    });

    ds.addElement(se2);
  });
}