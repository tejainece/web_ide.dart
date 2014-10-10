library ordered_list;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import '../drag_drop/drag_drop.dart';
import 'package:smoke/smoke.dart' as smoke;
import 'dart:mirrors';
import "package:template_binding/template_binding.dart" show nodeBind, templateBind, Scope;

import 'package:dockable/dockable.dart';

part "ordered_list_item.dart";

class DragStreams {
  StreamSubscription dragStart;
  StreamSubscription dragEnd;
  StreamSubscription dragEnter;
  StreamSubscription dragOver;
  StreamSubscription dragLeave;
  StreamSubscription drop;

  StreamSubscription click;
  StreamSubscription doubleClick;
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

  void dataChanged() {
    TemplateElement templ = this.querySelector("template");
    if (templ != null) {
      templ.attributes["repeat"] = '';
      templateBind(templ)..model = data;
    }
  }

  Map<HtmlElement, DragStreams> _dragStreams = new Map<HtmlElement, DragStreams>();

  OrderedList.created() : super.created() {
  }

  void ready() {
    super.ready();

    _template = querySelector("template");

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

  MutationObserver _thisObserver;
  void _onThisMutation(records, observer) {
    dataChanged();
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
        //TODO: onClicked _fireOnItemDoubleClicked(ch);
      });
      newStreams.doubleClick = ch.onDoubleClick.listen((MouseEvent me) {
        _fireOnItemDoubleClicked(me.target);
      });

      _dragStreams[ch] = newStreams;
    }
  }

  void _degisterDragHandlers(HtmlElement ch) {
    ch.draggable = false;
    DragStreams newStreams = _dragStreams.remove(ch);
    if (newStreams != null) {
      newStreams.dragStart.cancel();
      newStreams.dragEnd.cancel();
      newStreams.dragEnter.cancel();
      newStreams.dragOver.cancel();
      newStreams.dragLeave.cancel();
      newStreams.drop.cancel();
      newStreams.click.cancel();
      newStreams.doubleClick.cancel();
    }
  }

  void _onDragStart(MouseEvent event) {
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text', "");
    //TODO: set proper drag-image

    dynamic target = event.target;
    setDragData(_getModelForItem(target), target);
  }

  void _onDragEnd(MouseEvent event) {
    Element dragTarget = event.target;
    for (Element e in this.shadowRoot.children) {
      e.classes.remove('dragover');
    }
  }

  void _onDragEnter(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.add("dragover");
  }

  void _onDragOver(MouseEvent event) {
    // This is necessary to allow us to drop.
    event.preventDefault();
  }

  void _onDragLeave(MouseEvent event) {
    Element dropTarget = event.target;
    dropTarget.classes.remove('dragover');
  }

  void _onDrop(MouseEvent event) {
    HtmlElement target = event.target;
    target.classes.remove('dragover');
    if (hasDragData() && data != null) {
      if (canDrop == null || canDrop(getDragData())) {
        Object d = getDragData();
        int index;
        var td;
        if (target == this) {
          if (data.length != 0) {
            if (!data.contains(d)) {
              index = data.length;
            } else {
              index = data.length - 1;
            }
            td = data.last;
          } else {
            index = 0;
            td = null;
          }
        } else {
          td = _getModelForItem(target);
          index = data.indexOf(td);
        }
        //consume
        if (d != td) {
          if (data.contains(d)) {
            data.remove(d);
          }
          if (index >= 0) {
            data.insert(index, d);
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

  //events
  EventStreamProvider<CustomEvent> _itemDblClickedEventP = new EventStreamProvider<CustomEvent>("item-double-click");
  Stream<CustomEvent> get onItemDoubleClicked => _itemDblClickedEventP.forTarget(this);

  dynamic _getModelForItem(item) {
    dynamic ret = nodeBind(item).templateInstance.model;
    
    InstanceMirror im = reflect(ret);
    
    if(im.type.simpleName.toString() == 'Symbol("_GlobalsScope")') {
      ret = ret.model;
    }
    
    return ret;
  }

  void _fireOnItemDoubleClicked(HtmlElement item) {
    var event = new CustomEvent("item-double-click", canBubble: false, cancelable: false, detail: _getModelForItem(item));
    dispatchEvent(event);
  }
}
