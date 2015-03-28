library main;

import 'dart:html';
import 'package:dockable/spinner/spinner.dart';
import 'package:polymer/polymer.dart';

DivElement preview;

main() {
  initPolymer().run(() {
    Polymer.onReady.then((_) {
      SpinnerElm spinner = querySelector("spinner-elm"); 
      querySelector("#toggle").onClick.listen((_) {
        spinner.loading = !spinner.loading;
      });
    });
  });
}
