part of iconbutton;

/**
 * icon-options-button enables you to place an image centered in a button.
 *
 * Example:
 *
 *     <icon-button src="star.png"></icon-button>
 *
 * @class icon-button
 */
@CustomTag('icon-options-button')
class IconOptionsButton extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;
  
  SubMenu _submenu;

  IconOptionsButton.created() : super.created();

  @override
  void polymerCreated() {
    super.polymerCreated();
    widthChanged();
    heightChanged();
  }

  @override
  void ready() {
    super.ready();
    
    _submenu = shadowRoot.querySelector("#submenu");
  }

  @override
  void leftView() {
    _submenu.remove();
  }

  void showMenu(CustomEvent event) {
    _submenu.style.left = "${this.offsetLeft}px";
    _submenu.style.top = "${this.offsetTop+this.offsetHeight}px";
    if(event.detail) {
      //this.classes.add("open");
      _submenu.show = true;
      _submenu.onHide.listen((_) {
        open = false;
      });
    } else {
      open = false;
    }
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

  @published bool togglable = false;
  @published bool checked = false;

  @published bool open = false;

  @observable num get ICON_SIZE => 0.8;
  @observable num get PADDING_SIZE => 0.1;

  void openChanged() {
    _submenu.style.left = "${this.offsetLeft}px";
    _submenu.style.top = "${this.offsetTop+this.offsetHeight}px";
    if(open) {
      //this.classes.add("open");
      _submenu.show = true;
      //TODO: subscribe to onHide stream
      _submenu.onHide.listen((_) {
        open = false;
      });
    } else {
      //TODO: unsubscribe onHide stream
      if(_submenu.show) {
        _submenu.show = false;
      }
    }
  }

  void widthChanged() {
  }
  void heightChanged() {
  }

  //events
  EventStreamProvider<CustomEvent> _selectedEventP = new EventStreamProvider<CustomEvent>("selected");
  Stream<CustomEvent> get onSelected =>
        _selectedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _deselectedEventP = new EventStreamProvider<CustomEvent>("deselected");
  Stream<CustomEvent> get onDeselected =>
        _deselectedEventP.forTarget(this);
}
