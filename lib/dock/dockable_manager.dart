library dockable.manager;
import 'package:polymer/polymer.dart';
import '../container/dockable_container.dart';
import 'dart:html';

@CustomTag('dockable-manager')
class DockableManager extends PolymerElement {
  DockableContainer _rootContainer;
  DivElement _outdiv;

  DockableManager.created() : super.created() {
    _rootContainer = this.shadowRoot.querySelector("dockable-container");
    if(_rootContainer == null) {
      print("Dockable: No root contianer found!");
      assert(false);
    } else {
      _rootContainer.ContainerName = "0";//TODO: remove
      _rootContainer.style.backgroundColor = "green";//TODO: remove
      //_rootContainer.setRoot(this);
    }
  }
  
  bool dockToLeft(DockableContainer _newPanel) {
    return _rootContainer.dockToLeft(_newPanel);
  }
  
  bool dockToRight(DockableContainer _newPanel) {
    return _rootContainer.dockToRight(_newPanel);
  }
  
  bool dockToTop(DockableContainer _newPanel) {
    return _rootContainer.dockToTop(_newPanel);
  }
  
  bool dockToBottom(DockableContainer _newPanel) {
    return _rootContainer.dockToBottom(_newPanel);
  }
  
  void enteredView() {
    _outdiv = this.shadowRoot.querySelector(".dockable-manager-outdiv");
    if(_outdiv == null) {
      print("Dockable->DockableContainer: outdiv cannot be null!");
      assert(false);
    }
  }
}