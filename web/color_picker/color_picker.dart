library main;

import 'dart:html';
import 'package:dockable/colorpicker/color_picker.dart';
import 'package:polymer/polymer.dart';

ColorPicker cp;
DivElement preview;

main() async {
  await initPolymer();
  await Polymer.onReady;
  cp = new Element.tag("color-picker");
  document.body.children.add(cp);
  preview = querySelector("#preview");

  cp.onChanged.listen((_) {
    preview.style.backgroundColor = cp.color.rgbaString;
  });
}
