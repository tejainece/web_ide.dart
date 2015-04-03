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

  @published String label = "";

  DivElement _titleDiv;
  
  SubMenu _submenu;

  MenuItem.created() : super.created() {
  }

  @override
  void ready() {
    super.ready();
    _submenu = shadowRoot.querySelector("#submenu");
    
    _titleDiv = shadowRoot.querySelector(".title");
    assert(_titleDiv != null);
    
    onMouseOver.listen((MouseEvent me) {
      open = true;
    });
    
    onMouseLeave.listen((MouseEvent me) {
      open = false;
    });
  }

  @override
  void attached() {
    super.attached();
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