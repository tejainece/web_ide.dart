library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/dockable.dart';

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    PropertyEditor pe = new Element.tag("property-editor");
    mc.children.add(pe);

    PropertyCategory pc1 = new Element.tag("property-category");
    pc1.heading = "Geometry";
    pe.addCategory(pc1);

    PropertyItem pi1_1 = new Element.tag("property-item");
    pi1_1.heading = "Left";
    pi1_1.description = "Left";
    PropertyNumber left_ed = new  Element.tag("property-number");
    pi1_1.setEditor(left_ed);
    pc1.addItem(pi1_1);

    PropertyItem pi1_2 = new Element.tag("property-item");
    pi1_2.heading = "Top";
    PropertyNumber top_ed = new  Element.tag("property-number");
    pi1_2.setEditor(top_ed);
    pc1.addItem(pi1_2);


    PropertyCategory pc2 = new Element.tag("property-category");
    pc2.heading = "Appearance";
    pe.addCategory(pc2);

    PropertyItem pi2_1 = new Element.tag("property-item");
    pi2_1.heading = "Background color";
    PropertyColor bgcol_ed = new Element.tag("property-color");
    pi2_1.setEditor(bgcol_ed);
    bgcol_ed.onUpdated.listen((_) {
      document.body.style.backgroundColor = bgcol_ed.value.toString();
    });
    pc2.addItem(pi2_1);

    PropertyItem pi2_2 = new Element.tag("property-item");
    pi2_2.heading = "Background image";
    pc2.addItem(pi2_2);

    left_ed.value = 5;
    left_ed.min = 25;
    left_ed.step = 5;

    top_ed.value = 755;
    top_ed.max = 555;

  });
}
