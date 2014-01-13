part of dockable.menubar;

/*
 * TODO:
 * 1) Checked icon
 * 2) Submenu exists arrow
 */

@CustomTag('submenu-item')
class SubMenuItem extends SubMenuContentItem {
  @published String icon = "";
  @published String title = "";
  @observable bool checked;
  
  void checkableChanged() {
    if(checkable == true) {
    } else if(checkable == false) {
      checked = false;
    } else {
      checkable = false;
    }
  }
    
  void checkedChanged() {
    if(checked == true) {
      this.classes.add('checked');
    } else if(checked == false) {
      this.classes.remove('checked');
    } else {
      checked = false;
    }
  }
  
  DockableIcon _iconDiv;
  DivElement _titleDiv;
  
  SubMenuItem.created() : super.created() {
  }
  
  @override
  void enteredView() {
    super.enteredView();
    for(Element _el in this.children) {
      if(!SubMenu.isSubMenuItem(_el)) {
        _el.remove();
      } else {
        _el.remove();
        addItem(_el);
      }
    }
    _iconDiv = this.shadowRoot.querySelector(".icon");
    assert(_iconDiv != null);
    _titleDiv = this.shadowRoot.querySelector(".title");
    assert(_titleDiv != null);
    //TODO: should we add it to the body?
    document.body.children.add(_submenu);
    checkableChanged();
    checkedChanged();
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
  
  bool _isDecendantMenu(SubMenuItemBase arg_item) {
    return _submenu._isDecendantMenu(arg_item);
  }
  
  void select() {
    dispatchMenuSelectedEvent(this, this);
    _showSubMenu();
    if(checkable) {
      checked = !checked;
      dispatchMenuToggledEvent(this, this);
    }
  }
  
  
  void _showSubMenu() {
    if(_submenu.children.length != 0 && _submenu.show == false) {
      _submenu.style.left = "${this.offsetLeft+this.offsetWidth}px";
      _submenu.style.top = "${this.parent.offsetTop + this.offsetTop}px";
      _submenu.show = true;
    }
  }
  
  //Events
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>('menuselected');
  static const EventStreamProvider<CustomEvent> _TOGGLED_EVENT = const EventStreamProvider<CustomEvent>('menutoggled');
  
  Stream<CustomEvent> get onMenuSelected => _SELECTED_EVENT.forTarget(this);
  Stream<CustomEvent> get onMenuChecked => _TOGGLED_EVENT.forTarget(this);
  
  void dispatchMenuSelectedEvent(Element element, SubMenuItem item) {
    fire('menuselected', detail: item);
  }
  
  void dispatchMenuToggledEvent(Element element, SubMenuItem item) {
    fire('menutoggled', detail: item);
  }
}