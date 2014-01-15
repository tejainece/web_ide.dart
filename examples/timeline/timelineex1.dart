library main;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'package:dockable/timeline/timeline.dart';

main() {
  DivElement mc = querySelector('#main-container');
  initPolymer().run(() {    
    TimelineManager man = querySelector('#timeline');
  });
}