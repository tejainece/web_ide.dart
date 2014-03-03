library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../../lib/dockable.dart';

DockStage ds;

main() {
  initPolymer().run(() {
    ds = querySelector('#stage1');
    //ds.fit();
    //ds = new Element.tag("dock-stage");
    /*ds.style.width = "400px";
    ds.style.width = "220px";
    ds.stagewidth = 200;
    ds.stageheight = 200;
    //ds.fit();
    document.body.children.add(ds);*/
  });
}