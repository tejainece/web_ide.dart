part of propertyeditor;

@CustomTag('property-number')
class PropertyNumber extends PropertyBase {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  PropertyNumber.created() : super.created() {
  }

  DivElement _displayEl;
  TextInputElement _inputEl;

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _displayEl = shadowRoot.querySelector("#display");
    _inputEl = shadowRoot.querySelector("#input");

    assert(_displayEl != null && _inputEl != null);

    valueChanged();
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
      _inputEl.value = value.toString();
      _displayEl.classes.add("editing");
      _inputEl.classes.add("editing");
      _inputEl.focus();
    }
  }

  void _stopEditing() {
    _displayEl.classes.remove("editing");
    _inputEl.classes.remove("editing");
    if(value != _inputEl.value) {
      value = num.parse(_inputEl.value);
    }
  }

  /**
   * Value of the property.
   */
  @published num value = 0;

  @published bool editable = true;

  @published num min = -10000;
  @published num max = 10000;
  @published num step = 1;

  void minChanged() {
    if(min > max) {
      min = max;
    } else {
      if(value < min) {
        value = min;
      }
    }
  }

  void maxChanged() {
    if(max < min) {
      max = min;
    } else {
      if(value > max) {
        value = max;
      }
    }
  }

  void valueChanged() {
    if(value < min) {
      value = min;
    } else if(value > max) {
      value = max;
    } else {
      var event = new CustomEvent("updated",
                          canBubble: false, cancelable: false, detail: null);
      dispatchEvent(event);
    }
  }

  void editableChanged() {
    _stopEditing();
  }
}
