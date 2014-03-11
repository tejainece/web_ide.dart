part of menubar;

/*
 * TODO:
 * 1) Implement Option list of SubMenuItems (not so important)
 * 2) Fix width
 */

abstract class SubMenuItemBase extends PolymerElement {
  SubMenuItemBase.created() : super.created() {
  }

  SubMenu _parent_submenu;
}

abstract class SubMenuContentItem extends SubMenuItemBase {
  @published bool checkable;

  SubMenuContentItem.created() : super.created() {
  }

  SubMenu _submenu = new Element.tag('sub-menu');
  bool addItem(SubMenuItemBase arg_item);

  bool addItemBefore(SubMenuItemBase before, SubMenuItemBase arg_item);

  bool removeItem(SubMenuItemBase arg_item);

  num indexOf(SubMenuItemBase arg_item);

  bool hasSubmenu() {
    return _submenu.children.length > 0;
  }

  bool _isDecendantMenu(SubMenuItemBase arg_item) {
    return _submenu._isDecendantMenu(arg_item);
  }
}

@CustomTag('sub-menu')
class SubMenu extends PolymerElement {

  bool _isDecendantMenu(SubMenuItemBase arg_item) {
    bool ret = false;
    for(SubMenuItemBase _el in this.children) {
      if(_el == arg_item) {
        ret = true;
        break;
      }
      if(_el is SubMenuContentItem && _el._isDecendantMenu(arg_item)) {
        ret = true;
        break;
      }
    }
    return ret;
  }

  SubMenu.created() : super.created() {
  }

  void enteredView() {
    super.enteredView();
    for(Element _el in this.children) {
      if(!isSubMenuItem(_el)) {
        //_el.remove(); //TODO: implement me
      }
    }
  }

  void leftView() {
    this.show = false;
  }

  bool addItem(SubMenuItemBase arg_item) {
    bool ret = false;
    if(arg_item != null) {
      this.children.add(arg_item);
      arg_item._parent_submenu = this;
      ret = true;
    }
    return ret;
  }

  bool addItemBefore(SubMenuItemBase before, SubMenuItemBase arg_item) {
    bool ret = false;
    if(arg_item != null) {
      if(before != null) {
        int index = this.children.indexOf(before);
        if(index == -1) {
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
    if(ret == true) {
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
  @published bool show = false;

  void showChanged() {
    if(show) {
      /*_documentEndSubscr = document.onMouseDown.listen((MouseEvent e) {
        print("hide!!");
        bool shouldHide = false;
        if(e.target is SubMenuContentItem && _isDecendantMenu(e.target)) {
          SubMenuContentItem _smct = e.target;
          if(!_smct.checkable && !_smct.hasSubmenu()) {
            shouldHide = true;
          }
        } else {
          shouldHide = true;
        }
        if(shouldHide) {
          this.show = false;
        }
      });*/
      _documentKeyboardSubscr = document.onKeyDown.listen((KeyboardEvent e) {
        if(e.keyCode == KeyCode.ESC) {
          this.show = false;
        }
      });
      //TODO: should we add it to the body?
      document.body.children.add(this);
      //this.classes.add('active');
    } else {
      if(_documentEndSubscr != null) {
        _documentEndSubscr.cancel();
        _documentEndSubscr = null;
      }
      if(_documentKeyboardSubscr != null) {
        _documentKeyboardSubscr.cancel();
        _documentKeyboardSubscr = null;
      }
      //this.classes.remove('active');
      this.remove();
    }
  }
}