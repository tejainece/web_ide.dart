part of dockable;

//TODO: implement content
//TODO: implement animation

///Container implementation
@CustomTag('dockable-panel')
class DockablePanel extends DockContainer {
  
  DockablePanel.created() : super.created() {
  }
  
  /******************************Content********************************/
  addPanel(Element arg_panel, String arg_title) {
    TabItem tItem = new TabItem(arg_panel, arg_title);
    _tabs.addItem(tItem);
  }
  
  unDockMe() {
    if(_parentContainer != null) {
      _parentContainer.unDock(this);
    }
  }
  
  performLayout() {
    
  }
  
  void enteredView() {
    performLayout();
  }
  
  TabManager __tabs;
  TabManager get _tabs {
    if(__tabs == null) {
      __tabs = this.shadowRoot.querySelector("#tabs");
      assert(__tabs != null);
    }
    return __tabs;
  }
}