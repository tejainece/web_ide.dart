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

  SubMenu _submenu;

  IconListButton.created() : super.created();

  @override
  void polymerCreated() {
    super.polymerCreated();
    widthChanged();
    heightChanged();

    onClick.listen((MouseEvent e) {
      open = !open;
    });

    onMouseLeave.listen((MouseEvent e) {
      open = false;
    });
  }

  @override
  void ready() {
    super.ready();
    _submenu = shadowRoot.querySelector("#submenu");
  }

  //Properties
  /**
   * The URL of an image for the icon.
   */
  @published String src = '';

  @published String icon = '';

  /**
   * The size of the icon button.
   */
  @published int width = 24;
  @published int height = 24;

  @published bool open = false;

  void openChanged() {
    if (open) {
      /*_submenu.style.left = "${this.documentOffset.x}px";
      _submenu.style.top = "${this.documentOffset.y+this.offsetHeight}px";*/
      classes.add("open");
      _submenu.show = true;
    } else {
      classes.remove("open");
      if (_submenu.show) {
        _submenu.show = false;
      }
    }
  }

  void widthChanged() {
  }
  void heightChanged() {
  }
}
