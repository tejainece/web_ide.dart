part of menubar;

/*
 * TODO:
 * 1) Checked icon
 * 2) Submenu exists arrow
 */

@CustomTag('submenu-action-item')
class SubMenuActionItem extends PolymerElement {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;


  @published
  MenuAction action;

  IconView _iconDiv;
  DivElement _holder;

  SubMenu _submenu;

  SubMenuActionItem.created() : super.created() {
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
      _dispatchMenuSelectedEvent();
      print("${action.label} ${action.action}");
      if(action != null && action.action != null) {
        action.action();
      }
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

  void _dispatchMenuSelectedEvent() {
    fire('menuselected', detail: this);
  }

  void _dispatchMenuChangedEvent() {
    fire('changed', detail: this);
  }
}
