part of menubar;

/*
 * TODO:
 * 1) Checked icon
 * 2) Submenu exists arrow
 */

@CustomTag('submenu-item')
class SubMenuItem extends PolymerElement {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;


  @published String icon = "";
  @published String label = "";

  IconView _iconDiv;
  DivElement _holder;

  SubMenu _submenu;

  SubMenuItem.created() : super.created() {
  }

  @override
  void ready() {
    super.ready();

    _submenu = shadowRoot.querySelector("#submenu");

    _iconDiv = this.shadowRoot.querySelector(".icon");
    assert(_iconDiv != null);
    _holder = this.shadowRoot.querySelector("#holder");
    assert(_holder != null);

    onMouseDown.listen((MouseEvent me) {
      _dispatchMenuSelectedEvent(this);
    });

    onMouseOver.listen((MouseEvent me) {
      if (children.length != null) {
        //TODO: implement submenu
      }
    });
  }

  @override
  void attached() {
    super.attached();
  }

  @published bool open = false;
  void openChanged() {
    if(open) {
      _submenu.style.left = "${this.parent.offsetLeft + this.parent.offsetWidth}px";
      _submenu.style.top = "${this.parent.offsetTop + this.offsetTop}px";
      this.classes.add("open");
      _submenu.show = true;
    } else {
      if(_submenu.show) {
        _submenu.show = false;
      }
      this.classes.remove("open");
    }
  }

  //Events
  static const EventStreamProvider<CustomEvent> _SELECTED_EVENT = const EventStreamProvider<CustomEvent>('menuselected');
  static const EventStreamProvider<CustomEvent> _changed_eventP = const EventStreamProvider<CustomEvent>('changed');

  Stream<CustomEvent> get onMenuSelected => _SELECTED_EVENT.forTarget(this);
  Stream<CustomEvent> get onMenuChecked => _changed_eventP.forTarget(this);

  void _dispatchMenuSelectedEvent(SubMenuItem item) {
    fire('menuselected', detail: item);
  }

  void _dispatchMenuChangedEvent(Element element, SubMenuItem item) {
    fire('changed', detail: item);
  }
}
