part of dockable;

@CustomTag('dockable-toolbar-icon-item')
class ToolbarIconItem extends ToolbarItem {
  ToolbarIconItem.created() : super.created();
  
  /**
   * The URL of an image for the icon.
   */
  @published String src = '';
  
  /**
   * Sets if the icon button is togglable 
   */
  @published bool togglable = false;
  
  @override 
  void polymerCreated() {
    super.polymerCreated();
  }
}