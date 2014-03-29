part of menubar;

/*
 * TODO:
 * 1) Adjust icon position and size. Use flex layout
 */

@CustomTag('menu-item')
class MenuItem extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  @published bool hasicon = false;
  @published String icon = "";
  @published String heading = "";

  void hasiconChanged() {
    if(hasicon) {
      _iconDiv.classes.remove("noicon");
    } else {
      _iconDiv.classes.add("noicon");
    }
  }
  DivElement _iconDiv;
  DivElement _titleDiv;

  MenuItem.created() : super.created() {
    _titleDiv = this.shadowRoot.querySelector(".title");
    assert(_titleDiv != null);

    _iconDiv = this.shadowRoot.querySelector("#icon");
    assert(_iconDiv != null);

    hasicon = false;
  }

  @override
  void ready() {
    super.ready();
    _submenu.triggerItems.add(this);
    _submenu.onHide.listen((_) {
      open = false;
    });
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
    open = !open;
  }

  @published bool open = false;

  void openChanged() {
    if(open) {
      _submenu.style.left = "${this.offsetLeft}px";
      _submenu.style.top = "${this.offsetTop+this.offsetHeight}px";
      this.classes.add("open");
      _submenu.show = true;
      dispatchMenuSelectedEvent(this, this);
    } else {
      if(_submenu.show) {
        _submenu.show = false;
      }
      this.classes.remove("open");
    }
  }

  //Events
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>('menuselected');

  Stream<CustomEvent> get onMenuSelected => _SELECTED_EVENT.forTarget(this);

  void dispatchMenuSelectedEvent(Element element, MenuItem item) {
    fire('menuselected', detail: item);
  }
}