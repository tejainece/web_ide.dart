library media_listbox;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

part 'media_list_item.dart';

/*
 * TODO:
 * Implement static html addition of list-items
 */

/**
 * media-listbox is an element that displays list of details or options.
 *
 * Example:
 *
 *     <media-listbox multiselect="false"></media-listbox>
 *
 * @class media-listbox
 */
@CustomTag('media-listbox')
class MediaListbox extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  MediaListbox.created(): super.created() {
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _holder = shadowRoot.querySelector(".holder");
    assert(_holder != null);

    List<HtmlElement> initItems = new List<HtmlElement>();
    for (HtmlElement child in this.children) {
      if (child is MediaListItem) {
        addItem(child);
      } else {
        child.remove();
      }
    }
  }

  @override
  void attached() {
    super.attached();
  }

  DivElement _holder;

  bool addItem(MediaListItem item) {
    bool ret = false;
    if (item != null && !containsItem(item)) {
      _holder.children.add(item);
      item._added(this);
      ret = true;
    }
    return ret;
  }

  bool removeItem(MediaListItem item) {
    bool ret = false;
    /*
     * Remove item only if
     * 1) item is not null
     * 2) item is member of this listbox
     */
    if (item != null && item._listbox == this) {
      ret = _holder.children.remove(item);
    }
    if (ret) {
      item._deselect();
      item._removed();
    }
    return ret;
  }

  void removeAllItems() {
    List<Element> listEl = _holder.children.toList(growable: false);

    for (MediaListItem el in listEl) {
      removeItem(el);
    }
  }

  bool containsItem(MediaListItem item) {
    return _holder.contains(item);
  }

  /* selection */
  List<MediaListItem> _selectedItems = new List<MediaListItem>();
  void select(MediaListItem item) {
    /*
     * Select the item only if
     * 1) Not null
     * 2) Is member of the list
     * 3) Is not already selected
     */
    if (item != null && _holder.contains(item) && !_selectedItems.contains(item
        )) {
      if (multiselect) {
        _selectedItems.add(item);
        item._select();
        _fireOnChanged(item);
      } else {
        deselectAll();
        _selectedItems.add(item);
        item._select();
        _fireOnChanged(item);
      }
    }
  }

  void deselect(MediaListItem item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
      item._deselect();
      _fireOnChanged(item);
    }
  }

  void deselectAll() {
    for (MediaListItem item in _selectedItems) {
      item._deselect();
    }
    _selectedItems.clear();
  }

  List<MediaListItem> getSelected() => _selectedItems.toList(growable: false);

  /* Properties */
  @published
  bool multiselect = false;

  void multiselectChanged() {
    if (multiselect == false && _selectedItems.length > 1) {
      /* retain the latest selected item */
      MediaListItem item = _selectedItems.removeLast();
      deselectAll();
      _selectedItems.add(item);
    }
  }

  //events
  EventStreamProvider<CustomEvent> _changedEventP =
        new EventStreamProvider<CustomEvent>("changed");
  Stream<CustomEvent> get onChanged => _changedEventP.forTarget(this);

  void _fireOnChanged(MediaListItem item) {
    var event = new CustomEvent("changed", canBubble: false, cancelable:
                false, detail: item);
    dispatchEvent(event);
  }
}
