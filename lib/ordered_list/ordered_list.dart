@HtmlImport('ordered_list.html')
library ordered_list;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import '../drag_drop/drag_drop.dart';
import 'package:smoke/smoke.dart' as smoke;
import 'package:dockable/utils/dockable_utils.dart';
import "package:template_binding/template_binding.dart" show nodeBind, templateBind, Scope;

import 'package:dockable/dockable.dart';

class DragStreams {
  StreamSubscription dragStart;
  StreamSubscription dragEnd;
  StreamSubscription dragEnter;
  StreamSubscription dragOver;
  StreamSubscription dragLeave;
  StreamSubscription drop;

  StreamSubscription contextmenu;
  StreamSubscription click;
  StreamSubscription doubleClick;

  void cancel() {
    dragStart.cancel();
    dragEnd.cancel();
    dragEnter.cancel();
    dragOver.cancel();
    dragLeave.cancel();
    drop.cancel();
    click.cancel();
    doubleClick.cancel();
  }
}

class ListModel extends Observable {
  @observable 
  int index;
  
  @observable 
  bool selected;
  
  @observable 
  var item;
  
  ListModel(this.index, this.item, this.selected) {
    
  }
}

/**
 * A Polymer click counter element.
 */
@CustomTag('ordered-list')
class OrderedList extends SelectorHelper {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  TemplateElement _template;

  @published ObservableList data;

  DnDDropType canDrop;

  @published
  bool multi = false;

  @published
  bool selectable = false;

  void selectableChanged() {
    if (selectable) {
      target = this;
    } else {
      target = null;
    }
  }
  
  @observable
  ObservableList<ListModel> models = new ObservableList<ListModel>();
  
  @observable
  ListModel model = new ListModel(0, "something", false);

  void dataChanged() {
    TemplateElement templ = this.querySelector("template");
    if (templ != null) {
      templ.attributes["repeat"] = '';
      
      models.clear();
      
      int index = 0;
      for(var datael in data) {
        ListModel el = new ListModel(index++, datael, false);
        
        //print(datael);
        
        models.add(el);
      }
      
      templateBind(templ).model = models;
    }
  }

  Map<HtmlElement, DragStreams> _dragStreams = new Map<HtmlElement, DragStreams>();

  OrderedList.created() : super.created() {
  }

  void ready() {
    super.ready();

    //_template = querySelector("template");

    _thisObserver = new MutationObserver(_onThisMutation);
    _thisObserver.observe(this, childList: true);

    onDrop.listen(_onDrop);

    onDragOver.listen((event) {
      event.preventDefault();
    });

    onDragLeave.listen((event) {
      event.preventDefault();
    });
  }
  
  @override
  attached() {
    _template = querySelector("template");
    // Make sure they supplied a template in the content.
    if (_template == null) {
      throw '\n\nIt looks like you are missing the <template> '
          'tag in your <core-list-dart> content.';
    }
    if (templateBind(_template).bindingDelegate == null) {
      templateBind(_template).bindingDelegate = element.syntax;
    }
  }

  MutationObserver _thisObserver;
  void _onThisMutation(records, observer) {
    //dataChanged();
    for (MutationRecord record in records) {
      for (Node node in record.addedNodes) {
        if (node is HtmlElement) {
          _registerDragHandlers(node);
        }
      }
      for (Node node in record.removedNodes) {
        if (node is HtmlElement) {
          _degisterDragHandlers(node);
        }
      }
    }
  }

  void _registerDragHandlers(Element ch) {
    ch.draggable = true;
    if (!_dragStreams.containsKey(ch)) {
      DragStreams newStreams = new DragStreams();
      newStreams.dragStart = ch.onDragStart.listen(_onDragStart);
      newStreams.dragEnd = ch.onDragEnd.listen(_onDragEnd);
      newStreams.dragEnter = ch.onDragEnter.listen(_onDragEnter);
      newStreams.dragOver = ch.onDragOver.listen(_onDragOver);
      newStreams.dragLeave = ch.onDragLeave.listen(_onDragLeave);
      newStreams.drop = ch.onDrop.listen(_onDrop);

      newStreams.click = ch.onClick.listen((_) {
        _fireOnItemClicked(ch);
      });
      newStreams.doubleClick = ch.onDoubleClick.listen((MouseEvent me) {
        _fireOnItemDoubleClicked(me.target);
      });
      newStreams.contextmenu = ch.onContextMenu.listen((MouseEvent me) {
        _fireOnItemContextMenu(me.target);
      });

      _dragStreams[ch] = newStreams;
    }
  }

  void _degisterDragHandlers(HtmlElement ch) {
    ch.draggable = false;
    DragStreams newStreams = _dragStreams.remove(ch);
    if (newStreams != null) {
      newStreams.cancel();
    }
  }

  void _onDragStart(MouseEvent event) {
    HtmlElement evtarget = _getElement(event.target);

    print(evtarget.outerHtml);
    
    if (data.length != 0) {

      int foundIndex = _findIndexOfElement(evtarget);

      if (foundIndex != null && foundIndex < data.length) {
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('text', "");
        event.dataTransfer.setDragImage(evtarget, 0, 0);
        //TODO: set proper drag-image


        Object draggedData = getModelForItem(evtarget);
        setDragData(draggedData, evtarget, this, foundIndex);
      }
    }
  }

  void _onDragEnd(MouseEvent event) {
    HtmlElement evtarget = _getElement(event.target);
    for (Element e in this.shadowRoot.children) {
      e.classes.remove('dragover');
    }
    removeDragData();
  }

  void _onDragEnter(MouseEvent event) {
    HtmlElement evtarget = _getElement(event.target);
    evtarget.classes.add("dragover");
  }

  void _onDragOver(MouseEvent event) {
    // This is necessary to allow us to drop.
    event.preventDefault();
  }

  void _onDragLeave(MouseEvent event) {
    HtmlElement evtarget = _getElement(event.target);
    evtarget.classes.remove('dragover');
  }

  /*
   * onDrop event handler. Reordering and insertion using drag-n-drop is
   * handled here. It uses canDrop callback function to determine if dropping
   * of the item is allowed.
   */
  void _onDrop(MouseEvent event) {
    HtmlElement evtarget = _getElement(event.target);
    evtarget.classes.remove('dragover');

    if (hasDragData() && data != null) {
      Object droppedItem = getDragData();
      bool isReorder = getDragSource() == this;

      CanDropType cand = new CanDropType(droppedItem, isReorder);
      // if canDrop is null, accept drop
      if (canDrop == null || canDrop(cand)) {
        // find the new position to insert
        int newPosition;
        Object dropReceiverItem;
        if (evtarget == this) {
          if (data.length != 0) {
            if (!isReorder || !data.contains(droppedItem)) {
              // if the dropped item is not already in the list
              newPosition = data.length;
            } else {
              newPosition = data.length - 1;
            }
            dropReceiverItem = data.last;
          } else {
            newPosition = 0;
            dropReceiverItem = null;
          }
        } else {
          dropReceiverItem = getModelForItem(evtarget);
          newPosition = _findIndexOfElement(evtarget);
        }

        int dragIndex = getDragDataIndex();
        //consume
        if (!isReorder || droppedItem != dropReceiverItem || newPosition != dragIndex) {

          if (newPosition != null && newPosition >= 0) {
            // if it is reorder operation and the droppedItem is picked up from
            // this list, remove the existing item and put it in new place
            if (isReorder && dragIndex < data.length && data[dragIndex] == droppedItem) {
              data.removeAt(dragIndex);
            }

            data.insert(newPosition, droppedItem);
            removeDragData();
          }
        } else {
          removeDragData();
        }
      }
    }
    // Stop the browser from redirecting.
    event.stopPropagation();
  }

  HtmlElement _getElement(HtmlElement el) {
    HtmlElement ret;
    if (el == this) {
      ret = el;
    } else if (this.children.contains(el)) {
      ret = el;
    } else {
      HtmlElement tEL = el;
      while (tEL != null && !this.children.contains(tEL)) {
        tEL = tEL.parent;
      }
      if (tEL != null) {
        ret = tEL;
      }
    }

    return ret;
  }

  //events
  EventStreamProvider<CustomEvent> _itemDblClickedEventP = new EventStreamProvider<CustomEvent>("item-double-click");
  Stream<CustomEvent> get onItemDoubleClicked => _itemDblClickedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _itemClickedEventP = new EventStreamProvider<CustomEvent>("item-click");
  Stream<CustomEvent> get onItemClicked => _itemClickedEventP.forTarget(this);

  EventStreamProvider<CustomEvent> _itemContextMenuEventP = new EventStreamProvider<CustomEvent>("item-contextmenu");
  Stream<CustomEvent> get onItemContextMenu => _itemContextMenuEventP.forTarget(this);

  int _findIndexOfElement(HtmlElement searched) {
    int indexCnt = -1,
        foundIndex;
    Object indData = data[0];
    for (HtmlElement el in children) {
      Object d = getModelForItem(el);
      if (d == indData) {
        indexCnt++;
        if (el == searched) {
          foundIndex = indexCnt;
          break;
        }
        if (indexCnt + 1 < data.length) {
          indData = data[indexCnt + 1];
        } else {
          break;
        }
      }
    }

    return foundIndex;
  }

  void _fireOnItemContextMenu(HtmlElement item) {
    var event = new CustomEvent("item-contextmenu", canBubble: false, cancelable: false, detail: getModelForItem(item));
    dispatchEvent(event);
  }

  void _fireOnItemClicked(HtmlElement item) {
    var event = new CustomEvent("item-click", canBubble: false, cancelable: false, detail: getModelForItem(item));
    dispatchEvent(event);
  }

  void _fireOnItemDoubleClicked(HtmlElement item) {
    var event = new CustomEvent("item-double-click", canBubble: false, cancelable: false, detail: getModelForItem(item));
    dispatchEvent(event);
  }
}
