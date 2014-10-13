part of menubar;

/*
 * TODO:
 * 1) add item clicked event
 * 2) Fix the show and hide
 */

@CustomTag('sub-menu')
class SubMenu extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  SubMenu.created() : super.created() {
  }

  @override
  void ready() {
    showChanged();
  }

  void attached() {
    super.attached();
  }

  StreamSubscription<MouseEvent> _documentEndSubscr;
  StreamSubscription<KeyboardEvent> _documentKeyboardSubscr;

  /* properties */
  @published
  bool show = false;

  void showChanged() {
    if (show) {
      this.classes.add('show');
    } else {
      this.classes.remove('show');
      _dispatchHideEvent();
    }
  }

  //Events
  static const EventStreamProvider<CustomEvent> _hide_eventp = const EventStreamProvider<CustomEvent>('hide');

  Stream<CustomEvent> get onHide => _hide_eventp.forTarget(this);

  void _dispatchHideEvent() {
    new Timer(new Duration(milliseconds: 100), () {
      fire('hide', detail: this);
    });
  }
}
