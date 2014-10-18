part of timeline;

abstract class TimeLineRowInterface {
  dynamic processDrop(instance);
}

/**
 * timeline-row is a ruler widget.
 *
 * Example:
 *
 *     <timeline-row></timeline-row>
 *
 * @class ruler-widget
 */
@CustomTag('timeline-row')
class TimelineRow extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  @published
  ObservableList data = new ObservableList();

  @published
  TimeLineRowInterface item;

  @published int leftlimit = 0;

  @published int rightlimit = 0;

  @published double spacing = 5.0;

  @published
  int min = 1;

  SubMenu _contextMenu;

  TimelineRow.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Timeline-row');

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _contextMenu = shadowRoot.querySelector("#context-menu");

    onDrop.listen(_onDrop);

    onDragOver.listen((event) {
      event.preventDefault();
    });

    onDragLeave.listen((event) {
      event.preventDefault();
    });

    document.onClick.listen((MouseEvent) {
      _contextMenu.show = false;
    });
  }

  @override
  void attached() {
    super.attached();
  }

  @published String label = "";

  void _onDrop(MouseEvent event) {
    if (hasDragData()) {
      if (item != null && item is TimeLineRowInterface) {
        Object d = item.processDrop(getDragData());
        //consume
        if (d != null) {
          d.start = getTimeForLeft(event.offset.x);
          data.add(d);
          removeDragData();
        }
      }
    }
    // Stop the browser from redirecting.
    event.stopPropagation();
  }

  int getTimeForLeft(int arg_left) {
    if (spacing != 0) {
      return (arg_left ~/ spacing) + leftlimit;
    } else {
      return 0;
    }
  }
  
  Object _curItem;

  void elementContextMenu(CustomEvent event, detail, target) {
    _contextMenu.show = true;
    _curItem = (target as TimelineElement).data;
    event.preventDefault();
  }

  void deleteItem(CustomEvent event, detail, target) {
    item.remove(_curItem);
  }

  @published
  bool editable = true;
}
