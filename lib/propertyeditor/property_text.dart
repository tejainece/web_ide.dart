part of propertyeditor;

@CustomTag('property-text')
class PropertyText extends PropertyBase {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  PropertyText.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('PropertyText');

  /**
   * Value of the property.
   */
  @published String value = '';

  @published bool editable = true;

  DivElement _displayEl;
  TextInputElement _inputEl;

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _displayEl = shadowRoot.querySelector("#display");
    _inputEl = shadowRoot.querySelector("#input");

    assert(_displayEl != null && _inputEl != null);
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
      _inputEl.value = value;
      _displayEl.classes.add("editing");
      _inputEl.classes.add("editing");
      _inputEl.focus();
    }
  }

  void _stopEditing() {
    _displayEl.classes.remove("editing");
    _inputEl.classes.remove("editing");
    if(value != _inputEl.value) {
      value = _inputEl.value;
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
}
