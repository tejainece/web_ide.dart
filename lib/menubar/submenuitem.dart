part of menubar;

/*
 * TODO:
 * 1) Checked icon
 * 2) Submenu exists arrow
 */

@CustomTag('submenu-item')
class SubMenuItem extends SubMenuContentItem {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;


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
      _holder.classes.add('checked');
    } else if(checked == false) {
      _holder.classes.remove('checked');
    } else {
      checked = false;
    }
  }

  IconView _iconDiv;
  DivElement _holder;

  SubMenuItem.created() : super.created() {
  }

  @override
  void ready() {
    super.ready();
    _submenu.triggerItems.add(this);
    _submenu._parent_submenu_item = this;
  }

  @override
  void enteredView() {
    super.enteredView();
    for(Element _el in this.children) {
      if(!SubMenu.isSubMenuItem(_el)) {
        //_el.remove(); //TODO: implement this
      } else {
        _el.remove();
        addItem(_el);
      }
    }
    _iconDiv = this.shadowRoot.querySelector(".icon");
    assert(_iconDiv != null);
    _holder = this.shadowRoot.querySelector("#holder");
    assert(_holder != null);
    checkableChanged();
    checkedChanged();
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
    dispatchMenuSelectedEvent(this, this);
    _showSubMenu();
    if(checkable) {
      checked = !checked;
      _dispatchMenuChangedEvent(this, this);
    }
  }

  void _showSubMenu() {
    if(_submenu.children.length != 0 && _submenu.show == false && _parent_submenu != null) {
      _submenu.style.left = "${_parent_submenu.offsetLeft+_parent_submenu.offsetWidth}px";
      _submenu.style.top = "${this.parent.offsetTop + this.offsetTop}px";
      _submenu.show = true;
    }
  }



  //Events
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>('menuselected');
  static const EventStreamProvider<CustomEvent> _changed_eventP = const EventStreamProvider<CustomEvent>('changed');

  Stream<CustomEvent> get onMenuSelected => _SELECTED_EVENT.forTarget(this);
  Stream<CustomEvent> get onMenuChecked => _changed_eventP.forTarget(this);

  void dispatchMenuSelectedEvent(Element element, SubMenuItem item) {
    fire('menuselected', detail: item);
  }

  void _dispatchMenuChangedEvent(Element element, SubMenuItem item) {
    fire('changed', detail: item);
  }
}