part of toolbar;

@CustomTag('toolbar-icon-list-item')
class ToolbarIconListItem extends ToolbarItem {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  ToolbarIconListItem.created() : super.created();

  /**
   * The URL of an image for the icon.
   */
  @published String src = '';
  
  @PublishedProperty(reflect: true) String icon = '';

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void attached() {
    super.attached();
  }

  @override
  void detached() {
    super.detached();
  }

  void ready() {
    super.ready();
    _ic_bt = shadowRoot.querySelector("icon-list-button");
    assert(_ic_bt != null);
  }

  void set _set_size(int new_size) {
    this.style.width = "${new_size+9}px";
    this.style.height = "${new_size}px";

    _ic_bt.width = new_size;
    _ic_bt.height = new_size;
  }

  IconListButton _ic_bt;
}