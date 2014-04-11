part of media_listbox;

/*
 * TODO:
 * 1) add selected attribute
 */

/**
 * media-list-item is elements that can be added to the list-box
 *
 * Example:
 *
 *     <media-list-item></media-list-item>
 *
 * @class media-list-item
 */
@CustomTag('media-list-item')
class MediaListItem extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  CheckboxInputElement _checkbox;

  MediaListItem.created() : super.created() {
  }


  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
    _checkbox = shadowRoot.querySelector("#checkbox");
    assert(_checkbox != null);

    //TODO: how do we handle addition of selected items to the box?
    //print(attributes["selected"] != null && attributes["selected"] != "false");
  }

  MediaListbox _listbox;
  /*
   * Internal function. It should be only called by parent @ListBox when
   * the item is added to it.
   */
  void _added(MediaListbox listbox) {
    _listbox = listbox;
  }

  /*
   * Internal function. It should be only called by parent @ListBox when
   * the item is removed from it.
   */
  void _removed() {
    _listbox = null;
  }

  /* Selection */
  @published
  bool get selected {
    bool ret = false;
    if(_listbox != null) {
      ret = _listbox._selectedItems.contains(this);
    }
    return ret;
  }

  @published
  void set selected(bool arg_selected) {
    if(_listbox != null) {
      if(selected != arg_selected) {
        if(arg_selected) {
          _listbox.select(this);
        } else {
          _listbox.deselect(this);
        }
        notifyPropertyChange(#selected, !arg_selected, arg_selected);
      }
    } else {
      _deselect();
    }
  }

  void selectedChanged() {

  }

  /*
   * Callback when checkbox item changes(selected or deselected)
   */
  void selection_changed() {
    if(_checkbox != null && _checkbox.checked != selected) {
      //selected = _checkbox.checked;
      attributes["selected"] = _checkbox.checked.toString();
    }
  }

  /*
   * Internal function. It should be only called by parent @ListBox when
   * the item is selected.
   */
  void _select() {
    classes.add("selected");
    if(_checkbox != null && !_checkbox.checked) {
      _checkbox.checked = true;
    }
    /* TODO: generate selected event */
    internal_selected();
  }

  /*
   * Internal function. It should be only called by parent @ListBox when
   * the item is deselected.
   */
  void _deselect() {
    classes.remove("selected");
    if(_checkbox != null && _checkbox.checked) {
      _checkbox.checked = false;
    }
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
  String heading = "Item";

  @published
  String src = "";
}
