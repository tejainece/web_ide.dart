library menubar;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import '../icon/icon_view.dart';

part 'menuitem.dart';
part 'submenu.dart';
part 'submenuitem.dart';
part 'submenuactionitem.dart';
part 'submenuseparater.dart';
part 'menuaction.dart';

@CustomTag('menu-bar')
class Menubar extends PolymerElement {
  Menubar.created() : super.created() {
  }

  void attached() {
    super.attached();
  }
}