library main;

import 'dart:html';
import 'package:dockable/colorpicker/color_picker.dart';
import 'package:polymer/polymer.dart';

ColorPicker cp;
DivElement preview;

main() {
  initPolymer().run(() {
    Polymer.onReady.then((_) {
      cp = querySelector("#cp");
      preview = querySelector("#preview");

      cp.onChanged.listen((_) {
        preview.style.backgroundColor = cp.color.toRgbString();
      });

    });
  });
}
