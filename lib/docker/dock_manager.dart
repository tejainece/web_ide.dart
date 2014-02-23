part of dockable;

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
}