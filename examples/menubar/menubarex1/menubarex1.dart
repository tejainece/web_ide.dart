library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/menubar/menubar.dart';

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {
    SubMenuItem sm1_2_1 = querySelector('#Submenu1_2_1');
    //sm1_2_1.checkable = true;
  });
}