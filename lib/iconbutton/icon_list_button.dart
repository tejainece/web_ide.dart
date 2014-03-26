part of iconbutton;

/*
 * TODO:
 * 1) UI: Arrange icons properly
 * 2) implement onItemSelected event
 */

/**
 * icon-options-button enables you to place an image centered in a button.
 *
 * Example:
 *
 *     <icon-button src="star.png"></icon-button>
 *
 * @class icon-button
 */
@CustomTag('icon-list-button')
class IconListButton extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  IconListButton.created() : super.created();

  @override
  void polymerCreated() {
    super.polymerCreated();
    widthChanged();
    heightChanged();

    onClick.listen((_) {
      open = !open;
    });
  }

  @override
  void ready() {
    super.ready();

    _submenu.triggerItems.add(this);

    _submenu.onHide.listen((_) {
      open = false;
    });

    //remove non-SubMenuItemBase elements
    for(HtmlElement el_t in children) {
      if(el_t is SubMenuItemBase) {
        el_t.remove();
        addItem(el_t);
      } else {
        el_t.remove();
      }
    }
  }

  @override
  void leftView() {
    _submenu.remove();
  }

  SubMenu _submenu = new Element.tag('sub-menu');
  bool addItem(SubMenuItemBase arg_item) {
     bool ret = _submenu.addItem(arg_item);
     return ret;
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

  //Properties
  /**
   * The URL of an image for the icon.
   */
  @published String src = '';

  /**
   * The size of the icon button.
   */
  @published int width = 24;
  @published int height = 24;

  @published bool open = false;

  @observable num get ICON_SIZE => 0.8;
  @observable num get PADDING_SIZE => 0.1;

  void openChanged() {

    if(open) {
      _submenu.style.left = "${this.offsetLeft}px";
      _submenu.style.top = "${this.offsetTop+this.offsetHeight}px";
      classes.add("open");
      _submenu.show = true;
    } else {
      classes.remove("open");
      if(_submenu.show) {
        _submenu.show = false;
      }
    }
  }

  void widthChanged() {
  }
  void heightChanged() {
  }
}
