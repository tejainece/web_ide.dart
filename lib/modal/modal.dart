part of dockable;

@CustomTag('dockable-modal')
class DockableModal extends PolymerElement {
  
  DivElement _titlebarDiv;
  DivElement _contentDiv;
  DivElement _titleDiv;
  DivElement _iconDiv;
  DivElement _buttonsDiv;
  
  StreamSubscription<MouseEvent> mouseDownHandler;
  StreamSubscription<MouseEvent> mouseUpHandler;
  StreamSubscription<MouseEvent> mouseMoveHandler;
  
  Point _clickOffset;
  Point _initialMouse;
  Point _initialPos;

  DockableModal.created() : super.created() {
    _titlebarDiv = shadowRoot.querySelector('#titlebar');
    assert(_titlebarDiv != null);
    
    _contentDiv = shadowRoot.querySelector('#content');
    assert(_contentDiv != null);
    
    _titleDiv = shadowRoot.querySelector('#title');
    assert(_titleDiv != null);
    
    _iconDiv = shadowRoot.querySelector('#icon');
    assert(_iconDiv != null);
    
    _buttonsDiv = shadowRoot.querySelector('#buttons');
    assert(_buttonsDiv != null);
    
    mouseDownHandler = _titlebarDiv.onMouseDown.listen(_mousedown);
  }
  
  void enteredView() {
    //TODO: detect static content
  }
  
  //content
  Element _content;
  Element get content => _content;
  void set content(Element arg_content) {
    if(arg_content != null) {
      _content = arg_content;
    } else {
      //TODO: decorate new div element
      _content = new DivElement();
    }
    _content.children.clear();
    _content.children.add(_content);
  }
  
  //title
  String _title = "";
  String get title => _title;
  void set title(String arg_title) {
    if(arg_title != null) {
      _title = arg_title;
    } else {
      _title = "";
    }
    _titleDiv.text= _title;
  }
  
  //drag
  void _mousedown(MouseEvent event) {
    _startDragging(event);
    _clickOffset = event.offset;
    _initialMouse = event.page;
    _initialPos = new Point(offsetLeft, offsetTop);
    if (mouseMoveHandler != null) {
      mouseMoveHandler.cancel();
      mouseMoveHandler = null;
    }
    if (mouseUpHandler != null) {
      mouseUpHandler.cancel();
      mouseUpHandler = null;
    }
    
    mouseMoveHandler = window.onMouseMove.listen(_mousemove);
    mouseUpHandler = window.onMouseUp.listen(_mouseup);
  }
  
  void _mouseup(MouseEvent event) {
    _stopDragging(event);
    mouseMoveHandler.cancel();
    mouseMoveHandler = null;
    mouseUpHandler.cancel();
    mouseUpHandler = null;
  }
  
  void _startDragging(MouseEvent event) {
    /*if (dialog.eventListener != null) {
      dialog.eventListener.onDialogDragStarted(dialog, event);
    }*/
    
    document.body.style.userSelect = 'none';
  }
  
  void _stopDragging(MouseEvent event) {
    /*if (dialog.eventListener != null) {
      dialog.eventListener.onDialogDragEnded(dialog, event);
    }*/
    document.body.style.userSelect = 'all';
  }

  void _mousemove(MouseEvent event) {
    Point _currentpos = event.page;
    int dx = _currentpos.x - _initialMouse.x;
    int dy = _currentpos.y - _initialMouse.y;
    _performDrag(dx, dy);
  }
  
  void _performDrag(int dx, int dy) {
    int left = dx + _initialPos.x;
    int top = dy + _initialPos.y;
    this.style.left = "${left}px";
    this.style.top = "${top}px";
  }
}