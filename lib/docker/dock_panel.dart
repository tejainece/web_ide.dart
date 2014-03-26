part of docker;

//TODO: implement content
//TODO: implement animation

///Container implementation
@CustomTag('dock-panel')
class DockPanel extends DockContainerBase {

  DockPanel.created(): super.created() {
  }

  performLayout() {

  }

  void enteredView() {
    performLayout();
  }

  /*
   * Sets content of the panel to @[arg_content] element. If @[arg_content]
   * is null, the previous content is removed and nothing is added.
   */
  setContent(Element arg_content) {
    _content.children.clear();
    if(arg_content != null) {
      _content.children.add(arg_content);
    }
  }

  unDockMe() {
    if (_parentContainer != null) {
      _parentContainer.unDock(this);
    }
  }

  DivElement _contentDiv;
  DivElement get _content {
    if (_contentDiv == null) {
      _contentDiv = this.shadowRoot.querySelector("#contentdiv");
      assert(_contentDiv != null);
    }
    return _contentDiv;
  }
}
