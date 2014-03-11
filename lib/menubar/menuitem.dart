part of menubar;

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
  }

  @override
  void leftView() {
    _submenu.remove();
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
    if(_submenu.show) {
      _submenu.show = false;
      this.classes.remove("open");
    } else {
      /* make UI changes */
      _submenu.style.left = "${this.offsetLeft}px";
      _submenu.style.top = "${this.offsetTop+this.offsetHeight}px";

      this.classes.add("open");
      _submenu.show = true;
      dispatchMenuSelectedEvent(this, this);
    }
  }

  //Events
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>('menuselected');

  Stream<CustomEvent> get onMenuSelected => _SELECTED_EVENT.forTarget(this);

  void dispatchMenuSelectedEvent(Element element, MenuItem item) {
    fire('menuselected', detail: item);
  }
}