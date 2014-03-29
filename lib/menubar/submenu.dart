part of menubar;

/*
 * TODO:
 * 1) add item clicked event
 */

abstract class SubMenuItemBase extends PolymerElement {
  SubMenuItemBase.created(): super.created() {
  }

  SubMenu _parent_submenu;
}

abstract class SubMenuContentItem extends SubMenuItemBase {
  @published
  bool checkable;

  SubMenuContentItem.created(): super.created() {
  }

  SubMenu _submenu = new Element.tag('sub-menu');
  bool addItem(SubMenuItemBase arg_item);

  bool addItemBefore(SubMenuItemBase before, SubMenuItemBase arg_item);

  bool removeItem(SubMenuItemBase arg_item);

  num indexOf(SubMenuItemBase arg_item);

  bool hasSubmenu() {
    return _submenu.children.length > 0;
  }

  bool _isDecendantItemOf(SubMenu arg_submenu) {
    bool ret = false;
    if (_parent_submenu != null) {
      ret = _parent_submenu._isDecendantMenuOf(arg_submenu);
    }
    return ret;
  }
}

@CustomTag('sub-menu')
class SubMenu extends PolymerElement {

  SubMenu.created(): super.created() {
  }

  void enteredView() {
    super.enteredView();
    for (Element _el in this.children) {
      if (!isSubMenuItem(_el)) {
        //_el.remove(); //TODO: implement me
      }
    }
  }

  void leftView() {
    this.show = false;
  }

  bool addItem(SubMenuItemBase arg_item) {
    bool ret = false;
    if (arg_item != null) {
      this.children.add(arg_item);
      arg_item._parent_submenu = this;
      ret = true;
    }
    return ret;
  }

  bool addItemBefore(SubMenuItemBase before, SubMenuItemBase arg_item) {
    bool ret = false;
    if (arg_item != null) {
      if (before != null) {
        int index = this.children.indexOf(before);
        if (index == -1) {
          ret = false;
        } else {
          this.children.insert(index, arg_item);
          ret = true;
        }
      } else {
        this.children.add(arg_item);
        ret = true;
      }
    }
    if (ret == true) {
      arg_item._parent_submenu = this;
    }
    return ret;
  }

  bool removeItem(SubMenuItemBase arg_item) {
    bool ret = this.children.remove(arg_item);
    arg_item._parent_submenu = null;
    return ret;
  }

  num indexOf(SubMenuItemBase arg_item) {
    return this.children.indexOf(arg_item);
  }

  static bool isSubMenuItem(Object arg_item) {
    return arg_item is SubMenuItemBase;
  }

  StreamSubscription<MouseEvent> _documentEndSubscr;
  StreamSubscription<KeyboardEvent> _documentKeyboardSubscr;

  /* properties */
  @published
  bool show = false;

  void showChanged() {
    if (show) {
      _documentEndSubscr = document.onMouseDown.listen((MouseEvent e) {
        bool hide_t = true;
        if(triggerItems.contains(e.target)) {
          hide_t = false;
        } else {
          if (e.target is SubMenuContentItem) {
            SubMenuContentItem ci_t = e.target;
            if ((ci_t.checkable || ci_t.hasSubmenu()) && ci_t._isDecendantItemOf(
                this)) {
              hide_t = false;
            }
          }
        }

        if (hide_t) {
          show = false;
        }
      });
      _documentKeyboardSubscr = document.onKeyDown.listen((KeyboardEvent e) {
        if (e.keyCode == KeyCode.ESC) {
          show = false;
        }
      });
      document.body.children.add(this);
      //this.classes.add('active');
    } else {
      if (_documentEndSubscr != null) {
        _documentEndSubscr.cancel();
        _documentEndSubscr = null;
      }
      if (_documentKeyboardSubscr != null) {
        _documentKeyboardSubscr.cancel();
        _documentKeyboardSubscr = null;
      }
      //this.classes.remove('active');
      _dispatchHideEvent();
      remove();
    }
  }

  SubMenuContentItem _parent_submenu_item;
  List<HtmlElement> triggerItems = new List<HtmlElement>();

  bool _isDecendantMenuOf(SubMenu arg_submenu) {
    bool ret = false;
    if (arg_submenu == this) {
      ret = true;
    } else if (_parent_submenu_item != null) {
      ret = _parent_submenu_item._isDecendantItemOf(arg_submenu);
    }
    return ret;
  }

  //Events
  static const EventStreamProvider<CustomEvent> _hide_eventp = const EventStreamProvider<CustomEvent>('hide');

  Stream<CustomEvent> get onHide => _hide_eventp.forTarget(this);

  void _dispatchHideEvent() {
    fire('hide', detail: this);
  }
}
