part of list;

/**
 * list-item is elements that can be added to the list-box
 *
 * Example:
 *
 *     <list-item></list-item>
 *
 * @class dockable-icon
 */
@CustomTag('list-item')
class ListItem extends PolymerElement {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  ListItem.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Dockable.ListItem');

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();

    this.onClick.listen((_) {
      select();
    });
  }

  @override
  void ready() {
    super.ready();
  }

  ListBox _listbox;
  /*
   * Internal function. It should be only called by parent @ListBox when
   * the item is added to it.
   */
  void _added(ListBox listbox) {
    _listbox = listbox;
  }

  /*
   * Internal function. It should be only called by parent @ListBox when
   * the item is removed from it.
   */
  void _removed() {

  }

  /* Selection */

  bool get isSelected {
    bool ret = false;
    if(_listbox != null) {
      ret = _listbox._selectedItems.contains(this);
    }
    return ret;
  }

  void select() {
    if(_listbox != null) {
      _listbox.select(this);
    }
  }

  void deselect() {
    if(_listbox != null) {
      _listbox.deselect(this);
    }
  }

  /*
   * Internal function. It should be only called by parent @ListBox when
   * the item is selected.
   */
  void _select() {
    classes.add("selected");
    /* TODO: generate selected event */
    internal_selected();
  }

  /*
   * Internal function. It should be only called by parent @ListBox when
   * the item is deselected.
   */
  void _deselect() {
    classes.remove("selected");
    /* TODO: generate deselected event */
    internal_deselected();
  }

  /*
   * Internal api function. Is called by _select() method when an item is selected.
   * This method exists so that the derived classes can be notified when an item
   * is selected.
   */
  void internal_selected() {

  }

  /*
   * Internal api function. Is called by _deselect() method when an item is selected.
   * This method exists so that the derived classes can be notified when an item
   * is deselected.
   */
  void internal_deselected() {

  }

  /* Properties */
  @published
  String label = "Label";

  @published
  int height = 32;

  void heightChanged() {

  }
}
