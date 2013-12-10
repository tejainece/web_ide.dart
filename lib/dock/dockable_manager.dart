library dockable.manager;
import 'package:polymer/polymer.dart';
import '../container/dockable_container.dart';
import 'dart:html';

@CustomTag('dockable-manager')
class DockableManager extends PolymerElement {
  DockableContainer _rootContainer;
  DivElement _outdiv;
  //DockableContainer get root => _rootContainer;

  DockableManager.created() : super.created() {
    _rootContainer = this.shadowRoot.querySelector("dockable-container");
    if(_rootContainer == null) {
      print("Dockable: No root contianer found!");
      assert(false);
    } else {
      _rootContainer.ContainerName = "0";//TODO: remove
      _rootContainer.style.backgroundColor = "green";//TODO: remove
      _rootContainer.setRoot(this);
    }
  }
  
  bool dockToLeft(DockableContainer _newPanel) {
    bool accepted = true;
    if(_newPanel != null) {
      if(_rootContainer.direction == DockableContainer.DOCKABLE_DIRECTION_HORIZONTAL) {
        print('hori');
        _rootContainer.dockToLeft(_newPanel);
      } else {
        print('opps');
        DockableContainer newCont = new Element.tag('dockable-container');
        DockableContainer oldRoot = replaceRoot(newCont);
        newCont.dockToLeft(oldRoot);
        newCont.dockToLeft(_newPanel);
      }
    } else {
      accepted = false;
    }
    if(accepted == true) {
      _rootContainer.performLayout();
    }
    return accepted;
  }
  
  bool dockToTop(DockableContainer _newPanel) {
    bool accepted = true;
    if(_newPanel != null) {
      if(_rootContainer.direction == DockableContainer.DOCKABLE_DIRECTION_VERTICAL) {
        _rootContainer.dockToTop(_newPanel);
      } else {
        DockableContainer newCont = new Element.tag('dockable-container');
        DockableContainer oldRoot = replaceRoot(newCont);
        newCont.dockToTop(oldRoot);
        newCont.dockToTop(_newPanel);
      }
    } else {
      accepted = false;
    }
    _rootContainer.performLayout();
    return accepted;
  }
  
  DockableContainer replaceRoot(DockableContainer _newPanel) {
    DockableContainer ret = _rootContainer;
    _rootContainer.removeRoot();
    _rootContainer.remove();
    
    _outdiv.children.add(_newPanel);
    _rootContainer = _newPanel;
    _rootContainer.setRoot(this);
    
    _rootContainer.performLayout();
    return ret;
  }
  
  void enteredView() {
    _outdiv = this.shadowRoot.querySelector(".dockable-manager-outdiv");
    if(_outdiv == null) {
      print("Dockable->DockableContainer: outdiv cannot be null!");
      assert(false);
    }
  }
}