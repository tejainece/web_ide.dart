library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import '../../lib/dockable.dart';

//HueSlider _hor;
HsvPicker _picker1;
HueSlider _ver;
//HsvPicker _picker2;

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    _ver = querySelector("#hue-slider-vertical");
    _picker1 = querySelector("#hsv-picker1");
    //_hor = querySelector("#hue-slider-horizontal");

    _ver.onChanged.listen((e) {
      //document.body.style.backgroundColor = _ver.hueAsColor.toString();
      _picker1.hue = _ver.hue;
      //print(_ver.hue);
      //print("${_ver.hueAsColor.h} ${_ver.hueAsColor.s} ${_ver.hueAsColor.v}");
    });

    _picker1.onChanged.listen((_) {
      //print("${_picker1.color.h}");
      document.body.style.backgroundColor = _picker1.color.toString();
    });
  });
}