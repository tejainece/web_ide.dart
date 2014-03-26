library propertyeditor;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

import '../utils/dockable_utils.dart';
import '../colorpicker/color_picker.dart';

part 'property_category.dart';
part 'property_item.dart';
part 'property_text.dart';
part 'property_number.dart';
part 'property_color.dart';

/*
 * TODO:
 * 1) implement content width resize
 * 2) implement description
 * 3) implement sorting
 */

/**
 * property-editor.
 *
 * Example:
 *
 *     <property-editor src="star.png"></property-editor>
 *
 * @class property-editor
 */
@CustomTag('property-editor')
class PropertyEditor extends PolymerElement {

  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  PropertyEditor.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Dockable.PropertyEditor');

  @override
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
    for(HtmlElement el in this.children) {
      //print(el is PropertyCategory);

    }
  }

  DivElement _contentDiv;
  DivElement get _content {
    if(_contentDiv == null) {
      _contentDiv = shadowRoot.querySelector("#content");
      assert(_contentDiv != null);
    }
    return _contentDiv;
  }

  void addCategory(PropertyCategory arg_category) {
    if(arg_category != null && arg_category._parent == null) {
      _content.children.add(arg_category);
      arg_category._parent = this;
    }
  }

  void removeCateogry(PropertyCategory arg_category) {
    if(arg_category._parent == this) {
      _content.children.remove(arg_category);
      arg_category._parent = null;
    }
  }

  //properties
  //TODO: @published double contentWidthRatio = 0.6;

  @observable String get description => _description;
  @observable String _description = "Description";

  void _setDescription(PropertyItem item) {
    String old_desc = _description;
    _description = item.description;
    this.notifyPropertyChange(#description, old_desc, _description);
  }
}
