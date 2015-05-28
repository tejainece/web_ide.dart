library main;

import 'dart:html';
import 'package:dockable/stage/stage.dart';
import 'package:polymer/polymer.dart';

DockStage cp;
DivElement preview;

int red_fontsize = 0;

main() async {
  await initPolymer();
  await Polymer.onReady;
  
  //cp = new Element.tag("dock-stage");
  cp = querySelector("dock-stage");
  cp.stagewidth = 200;
  cp.stageheight = 200;
  
  //document.body.children.add(cp);

  StageElement newel0 = new Element.tag("stage-element");
  newel0.left = 0;
  newel0.width = 50;
  newel0.height = 20;
  newel0.style.backgroundColor = "red";
  newel0.text = "red";
  cp.children.add(newel0);

  StageElement newel1 = new Element.tag("stage-element");
  newel1.left = 60;
  newel1.width = 50;
  newel1.height = 20;
  newel1.style.backgroundColor = "orange";
  cp.children.add(newel1);

  StageElement newel2 = new Element.tag("stage-element");
  newel2.left = 120;
  newel2.width = 50;
  newel2.height = 20;
  newel2.style.backgroundColor = "blue";
  newel2.movable = false;
  cp.children.add(newel2);

  /*for(int i = 0; i <= 2; i++) {
        StageElement newel = new Element.tag("stage-element");
        newel.left = i * 20;
        newel.width = 20;
        newel.height = 20;
        cp.addElement(newel);
      }*/

  ButtonElement butRedFs = querySelector("#red-fontsize");
  butRedFs.onClick.listen((_) {
    List items = [8, 12, 16, 20, 24, 32, 36, 40];

    newel0.fontsize = items[red_fontsize];
    print("In app ${items[red_fontsize]}");

    red_fontsize = ++red_fontsize % items.length;
  });
  
  ButtonElement addItemBut = querySelector("#add-item");
  addItemBut.onClick.listen((_) {
    print("Adding item");
    StageElement newel = new Element.tag("stage-element");
    newel.left = 60;
    newel.width = 50;
    newel.height = 20;
    newel.style.backgroundColor = "orange";
    cp.children.add(newel);
    print(newel.width);
  });
}
