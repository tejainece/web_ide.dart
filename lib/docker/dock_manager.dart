@HtmlImport('dock_conatiner.html')
@HtmlImport('dock_manager.html')
@HtmlImport('dock_multi_panel.html')
@HtmlImport('dock_panel.html')
library docker;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import '../tabs/tab_manager.dart';
import '../splitter/splitter.dart';

part 'dock_container_base.dart';
part 'dock_container.dart';
part 'dock_panel.dart';
part 'dock_multi_panel.dart';

/*
 * implement dockTo*Of methods
 */

@CustomTag('dock-manager')
class DockManager extends PolymerElement {
  DockContainer _rootContainer;
  DivElement _outdiv;

  DockManager.created() : super.created() {
    _rootContainer = this.shadowRoot.querySelector("#container");
    assert(_rootContainer != null);
  }

  bool dockToLeft(DockContainerBase newContainer, [DockContainerBase leftOf]) {
    return _rootContainer.dockToLeft(newContainer, leftOf);
  }

  bool dockToRight(DockContainerBase newContainer, [DockContainerBase rightOf]) {
    return _rootContainer.dockToRight(newContainer, rightOf);
  }

  bool dockToTop(DockContainerBase newContainer, [DockContainerBase topOf]) {
    return _rootContainer.dockToTop(newContainer, topOf);
  }

  bool dockToBottom(DockContainerBase newContainer, [DockContainerBase bottomOf]) {
    return _rootContainer.dockToBottom(newContainer, bottomOf);
  }
}