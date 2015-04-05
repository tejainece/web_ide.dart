library main;

import 'dart:html';
import 'package:dockable/spinner/spinner.dart';
import 'package:polymer/polymer.dart';

DivElement preview;

main() async {
  await initPolymer();
  await Polymer.onReady;
  
  SpinnerElm spinner = querySelector("spinner-elm");
  querySelector("#toggle").onClick.listen((_) {
    spinner.loading = !spinner.loading;
  });
}
