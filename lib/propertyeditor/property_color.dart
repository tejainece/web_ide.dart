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
  }

  DivElement _colorDispEl;
  DivElement _displayEl;
  ColorPicker _inputEl;

  @override
  void polymerCreated() {
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
      value = _inputEl.color;
      _colorDispEl.style.backgroundColor = _inputEl.color.toString();
      _fire_updated_event();
    });

    assert(_colorDispEl != null && _displayEl != null && _inputEl != null);
  }

  @override
  void attached() {
    super.attached();
    document.body.children.add(_inputEl);
  }

  @override
  void detached() {
    super.detached();
    document.body.children.remove(_inputEl);
  }

  StreamSubscription _onBlur;

  void handleBlur(FocusEvent event) {
    _stopEditing();
  }

  void startEditing() {
    _stopEditing();
    if (editable) {
      _onBlur = document.onMouseDown.listen((MouseEvent e) {
        if (e.target != _inputEl) {
          _stopEditing();
        }
      });
      _inputEl.color = value;
      _inputEl.style.left = "${getBoundingClientRect().left}px";
      _inputEl.style.top = "${getBoundingClientRect().top + getBoundingClientRect().height}px";
      _inputEl.style.display = "block";
      _inputEl.focus();
    }
  }

  void _stopEditing() {
    if (_onBlur != null) {
      _onBlur.cancel();
      _onBlur = null;
    }
    _inputEl.style.display = "none";

  }

  /**
   * Value of the property.
   */
  @published
  ColorVal value = new ColorVal();

  @published
  bool editable = true;

  void valueChanged() {
    _fire_updated_event();
  }

  void editableChanged() {
    _stopEditing();
  }

  void _fire_updated_event() {
    var event = new CustomEvent("updated", canBubble: false, cancelable: false, detail: null);
    dispatchEvent(event);
  }
}
