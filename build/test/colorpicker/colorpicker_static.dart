library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../lib/dockable.dart';

ColorPicker _pic;
ButtonInputElement _for_col;

List<ColorVal> colors = [new ColorVal.fromRGB(255, 0, 0),
                         new ColorVal.fromRGB(0, 255, 0),
                         new ColorVal.fromRGB(0, 0, 255),
                         new ColorVal.fromRGB(165, 255, 0),
                         new ColorVal.fromRGB(44, 155, 33),
                         new ColorVal.fromRGB(155, 0, 200)
                         ];
int index = 0;

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    _pic = querySelector("#color-picker");
    _pic.color = colors[index];

    _pic.onChanged.listen((_) {
      document.body.style.backgroundColor = _pic.color.toString();
    });

    _for_col = querySelector("#color_change_for");

    _for_col.onClick.listen((_) {
      ++index;
      index = index % colors.length;
      _pic.color = colors[index];
    });
  });
}