library docker;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import '../tabs/tab_manager.dart';
import '../splitter/splitter.dart';

part 'dock_container.dart';
part 'dockable_container.dart';
part 'dockable_panel.dart';

/*
 * implement dockTo*Of methods
 */

@CustomTag('dock-manager')
class DockManager extends PolymerElement {
  DockableContainer _rootContainer;
  DivElement _outdiv;

  DockManager.created() : super.created() {
    _rootContainer = this.shadowRoot.querySelector("dockable-container");
    if(_rootContainer == null) {
      print("Dockable: No root contianer found!");
      assert(false);
    } else {
      _rootContainer.style.backgroundColor = "green";//TODO: remove
    }
  }

  bool dockToLeft(DockContainer newContainer, [DockContainer leftOf]) {
    return _rootContainer.dockToLeft(newContainer, leftOf);
  }

  bool dockToRight(DockContainer newContainer, [DockContainer rightOf]) {
    return _rootContainer.dockToRight(newContainer, rightOf);
  }

  bool dockToTop(DockContainer newContainer, [DockContainer topOf]) {
    return _rootContainer.dockToTop(newContainer, topOf);
  }

  bool dockToBottom(DockContainer newContainer, [DockContainer bottomOf]) {
    return _rootContainer.dockToBottom(newContainer, bottomOf);
  }
}