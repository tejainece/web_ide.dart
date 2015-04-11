library main;

import 'dart:html';
import 'package:dockable/ordered_list/ordered_list.dart';
import 'package:polymer/polymer.dart';

OrderedList cp;
OrderedList ol2;
DivElement preview;

class Data extends Object with Observable {
  @observable
  String title;
  
  @observable
  String subtitle;

  Data(this.title, this.subtitle) {}
}

main() async {
  await initPolymer();
  await Polymer.onReady;
  cp = querySelector("#ordered-list1");
  cp.data = new ObservableList.from(
      [new Data("Title1.1", "Subtitle1.1"), new Data("Title1.2", "Subtitle1.2")]);

  ol2 = querySelector("#ordered-list2");
  ol2.data = new ObservableList.from(
      [new Data("Title2.1", "Subtitle2.1"), new Data("Title2.2", "Subtitle2.2")]);;

  querySelector("#refresh").onClick.listen((_) {
  });
}
