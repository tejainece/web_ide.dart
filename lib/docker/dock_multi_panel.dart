part of docker;

//TODO: implement content
//TODO: implement animation

///Container implementation
@CustomTag('dock-multi-panel')
class DockMultiPanel extends DockContainerBase {

  DockMultiPanel.created(): super.created() {
  }

  performLayout() {

  }

  @override
  void attached() {
    super.attached();
    performLayout();
  }

  void ready() {
    super.ready();
    //TODO: added statically added children
  }

  /******************************Content********************************/
  addPanel(Element arg_panel, String arg_title) {
    TabItem tItem = new TabItem(arg_panel, arg_title);
    _tabs.addItem(tItem);
  }

  removePanel(Element arg_panel) {
    //TODO: implement
  }

  unDockMe() {
    if (_parentContainer != null) {
      _parentContainer.unDock(this);
    }
  }

  TabManager _tabElement;
  TabManager get _tabs {
    if (_tabElement == null) {
      _tabElement = this.shadowRoot.querySelector("#tabs");
      assert(_tabElement != null);
    }
    return _tabElement;
  }
}
