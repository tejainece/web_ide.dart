part of propertyeditor;

@CustomTag('property-dropdown')
class PropertyDropdown extends PropertyBase {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  PropertyDropdown.created() : super.created() {
  }
  
  @published
  ObservableList items = new ObservableList();

  /**
   * Value of the property.
   */
  @published int value = 0;

  @published bool editable = true;

  DivElement _displayEl;
  
  OptionBox _optionbox = new Element.tag('option-box');

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _displayEl = shadowRoot.querySelector("#display");
    
    _optionbox.style.position = 'absolute';
    _optionbox.style.display = 'none';
    _optionbox.style.height = "200px";
    _optionbox.multi = false;
    document.body.children.add(_optionbox);

    assert(_displayEl != null);
  }
  
  @override
  void detached() {
    if(_stopSub != null) {
      _stopSub.cancel();
      _stopSub = null;
    }
  }

  void handleBlur(FocusEvent event) {
    _stopEditing();
  }

  void handleKeydown(KeyboardEvent event) {
    if(event.keyCode == KeyCode.ENTER) {
      _stopEditing();
    }
  }

  void startEditing() {
    if(editable) {
      _optionbox.style.left = "${this.documentOffset.x-4}px";
      _optionbox.style.top = "${this.documentOffset.y+this.offsetHeight}px";
      _optionbox.style.width = "${this.offsetWidth+8}px";
      _optionbox.children.clear();
      for(Object item in items) {
        OptionboxItem oitem = new Element.tag("optionbox-item");
        oitem.label = "${item}";
        _optionbox.children.add(oitem);
      }
      _optionbox.selected = [value];
      _optionbox.style.display = 'block';
      
      if(_stopSub != null) {
        _stopSub.cancel();
        _stopSub = null;
      }
      _stopSub = document.body.onMouseUp.listen((MouseEvent me) {
        Element target = me.target;
        print(target);
        if(target != this) {
          if(target == _optionbox || _optionbox.children.contains(target)) {
            new Timer(new Duration(milliseconds: 100), _stopEditing);
          } else {
            _stopEditing();
          }
        }
      });
    }
  }

  void _stopEditing() {
    //TODO: set the value from choosen
    _optionbox.style.display = 'none';
    if(_stopSub != null) {
      _stopSub.cancel();
      _stopSub = null;
    }
    if(_optionbox.selected.length > 0) {
      value = _optionbox.selected[0];
      notifyPropertyChange(#value, 0, value);
      print("here ${value}");
    }
  }

  void valueChanged() {
    var event = new CustomEvent("updated",
              canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }

  void editableChanged() {
    _stopEditing();
  }
  
  StreamSubscription _stopSub;
}
