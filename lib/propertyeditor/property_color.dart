part of propertyeditor;

/*
 * TODO:
 * Observable color
 */

@CustomTag('property-color')
class PropertyColor extends PropertyBase {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  PropertyColor.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('PropertyColor');

  DivElement _colorDispEl;
  DivElement _displayEl;
  ColorPicker _inputEl;

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _colorDispEl = shadowRoot.querySelector("#color-disp");

    _displayEl = shadowRoot.querySelector("#display");
    _inputEl = new Element.tag("color-picker");
    _inputEl.style.display = "none";
    _inputEl.style.position = "absolute";
    _inputEl.onChanged.listen((_) {
      if(color != _inputEl.color) {
        color = _inputEl.color;
        _colorDispEl.style.backgroundColor = _inputEl.color.toString();
        _fire_updated_event();
      }
    });

    assert(_colorDispEl != null && _displayEl != null && _inputEl != null);
  }

  @override
  void enteredView() {
    super.enteredView();
    document.body.children.add(_inputEl);
  }

  @override
  void leftView() {
    super.leftView();
    document.body.children.remove(_inputEl);
  }

  StreamSubscription _onBlur;

  void handleBlur(FocusEvent event) {
    _stopEditing();
  }

  void startEditing() {
    _stopEditing();
    if(editable) {
      _onBlur = document.onMouseDown.listen((MouseEvent e) {
        if(e.target != _inputEl) {
          _stopEditing();
        }
      });
      _inputEl.color = color;
      _inputEl.style.left = "${getBoundingClientRect().left}px";
      _inputEl.style.top = "${getBoundingClientRect().top + getBoundingClientRect().height}px";
      _inputEl.style.display = "block";
      _inputEl.focus();
    }
  }

  void _stopEditing() {
    if(_onBlur != null) {
      _onBlur.cancel();
      _onBlur = null;
    }
    _inputEl.style.display = "none";

  }

  /**
   * Value of the property.
   */
  @published String value = '';

  @published bool editable = true;

  @published ColorVal color;

  void colorChanged() {
    if(color != null) {

    } else {
      color = new ColorVal.fromRGB(255, 255, 255);
    }
  }

  void valueChanged() {

  }

  void editableChanged() {
    _stopEditing();
  }

  void _fire_updated_event() {
    var event = new CustomEvent("updated",
                  canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }
}
