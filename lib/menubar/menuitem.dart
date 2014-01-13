part of dockable.menubar;

@CustomTag('menu-item')
class MenuItem extends PolymerElement {
  @published String icon = "";
  @published String title = "";
  
  MenuItem _parent = null;
  
  DockableIcon _icon;
  DivElement _titleDiv;

  MenuItem.created() : super.created() {
    _titleDiv = this.shadowRoot.querySelector(".title");
    assert(_titleDiv != null);
    _icon = this.shadowRoot.querySelector(".icon");
    assert(_icon != null);
  }
  
  @override
  void enteredView() {
    super.enteredView();
    //TODO: add all tabs in content
    for(Element _el in this.children) {
      if(!SubMenu.isSubMenuItem(_el)) {
        _el.remove();
      } else {
        _el.remove();
        addItem(_el);
      }
    }
    //TODO: should we add it to the body?
    document.body.children.add(_submenu);
  }
  
  @override
  void leftView() {
    //TODO: should we add it to the body?
    document.body.children.remove(_submenu);
  }
  
  SubMenu _submenu = new Element.tag('sub-menu');
  bool addItem(SubMenuItemBase arg_item) {
    return _submenu.addItem(arg_item);
  }
  
  bool addItemBefore(SubMenuItemBase before, SubMenuItemBase arg_item) {
    return _submenu.addItemBefore(before, arg_item);
  }
  
  bool removeItem(SubMenuItemBase arg_item) {
    return _submenu.removeItem(arg_item);
  }
  
  num indexOf(SubMenuItemBase arg_item) {
    return _submenu.indexOf(arg_item);
  }
  
  void select() {
    dispatchMenuSelectedEvent(this, this);
    _showSubMenu();
  }
  
  
  void _showSubMenu() {
    if(_submenu.children.length != 0 && _submenu.show == false) {
      _submenu.style.left = "${this.offsetLeft}px";
      _submenu.style.top = "${this.offsetTop+this.offsetHeight}px";
      _submenu.show = true;
    }
  }
  
  //Events
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>('menuselected');
  
  Stream<CustomEvent> get onMenuSelected => _SELECTED_EVENT.forTarget(this);
  
  void dispatchMenuSelectedEvent(Element element, MenuItem item) {
    fire('menuselected', detail: item);
  }
}