@HtmlImport('optionbox.html')
@HtmlImport('optionbox_item.html')
@HtmlImport('optionbox_item_plain1.html')
library optionbox;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import 'package:dockable/dockable.dart';

part 'optionbox_item.dart';

/*
 * TODO:
 * Implement static html addition of list-items
 */

/**
 * list-box is an element that displays list of details or options.
 *
 * Example:
 *
 *     <list-box multiselect="false"></list-box>
 *
 * @class list-box
 */

@CustomTag('option-box')
class OptionBox extends SelectorHelper {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  OptionBox.created(): super.created() {
  }

  @override
  void polymerCreated() {
    super.polymerCreated();
  }
  
  @override
  void ready() {
    super.ready();

    this.target = this;
  }
  
  @published
  bool multi = false;
}
