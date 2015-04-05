library main;

import 'dart:html';
import 'package:dockable/listbox/listbox.dart';
import 'package:polymer/polymer.dart';

import 'package:dockable/utils/dockable_utils.dart';

import 'package:polymer_expressions/filter.dart';

DivElement preview;

class StringToInt extends Transformer<String, int> {
  String forward(int i) => '$i';
  int reverse(String s) {
    try {
      return int.parse(s);
    } catch (e) {
      return 0;
    }
  }
}

class MyModel extends Object with Observable {
  MyModel() {
    new PathObserver(this, "selItem").open((e) => selItemChanged());
  }

  @observable
  ObservableList data = new ObservableList.from([
    new Data("Object1", "Detail1", "blue"),
    new Data("Object2", "Detail2", "green"),
    new Data("Object3", "Detail3", "orange"),
    new Data("Object4", "Detail4", "gray"),
  ]);

  @observable
  Data selItem;

  @observable
  int selIndex;

  void selItemChanged() {
    print("${selItem}");
  }

  void add(_) {
    data.add(new Data("Object", "Detail", "orange"));
  }

  void select(MouseEvent event) {
    ListBoxModel l_mod = getModelForItem(event.target);
    l_mod.select();
  }

  final asInteger = new StringToInt();
}

class Data extends Object with Observable {
  @observable
  String title;

  @observable
  String subtitle;

  @observable
  String color;

  Data(this.title, this.subtitle, this.color) {}

  String toString() {
    return "${title} ${subtitle} ${color}";
  }
}

main() async {
  await initPolymer();
  await Polymer.onReady;

  AutoBindingElement template =
      querySelector('#auto-bind') as AutoBindingElement;
  var model = template.model = new MyModel();
}
