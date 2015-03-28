library main;

import 'dart:html';
import 'package:dockable/ordered_list/ordered_list.dart';
import 'package:polymer/polymer.dart';

OrderedList cp;
OrderedList ol2;
DivElement preview;

class Data {
  String title;
  String subtitle;

  Data(this.title, this.subtitle) {

  }
}

main() {
  initPolymer().run(() {
    Polymer.onReady.then((_) {
      cp = querySelector("#ordered-list1");
      cp.data = new ObservableList.from([new Data("Title1", "Subtitle1"), new Data("Title2", "Subtitle2")]);

      ol2 = querySelector("#ordered-list2");
      ol2.data = new ObservableList.from([new ObservableList.from([new Data("Title1", "Subtitle1"), new Data("Title2", "Subtitle2")]), new ObservableList.from([new Data("Title1", "Subtitle1"), new Data("Title2", "Subtitle2")])]);
      
      
      querySelector("#refresh").onClick.listen((_) {
        ol2.data[0] = new ObservableList.from([new Data("Title1", "Subtitle1"), new Data("Title2", "Subtitle2")]);
        ol2.models[0].index = 5;
      });
    });
  });
}
