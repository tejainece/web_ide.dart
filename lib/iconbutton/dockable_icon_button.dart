// Copyright (c) 2013, the polymer_elements.dart project authors.  Please see 
// the AUTHORS file for details. All rights reserved. Use of this source code is 
// governed by a BSD-style license that can be found in the LICENSE file.
// This work is a port of the polymer-elements from the Polymer project, 
// http://www.polymer-project.org/. 
library dockable.iconbutton;

import 'dart:async';

import 'package:polymer/polymer.dart';

import '../icon/dockable_icon.dart';

/*
 * TODO:
 * 1) Two modes: Toggle mode and Click mode
 * 2) onClick() stream
 * 3) onSelect() stream
 * 
 * Show border on mouse over
 */

/**
 * dockable-ui-icon-button enables you to place an image centered in a button.
 *
 * Example:
 *
 *     <dockable-button src="star.png"></dockable-icon-button>
 *
 * @class dockable-icon-button
 */
@CustomTag('dockable-icon-button')
class DockableIconButton extends PolymerElement {
  DockableIconButton.created() : super.created();
  
  @override 
  void polymerCreated() {
    super.polymerCreated();
    sizeChanged();
    
    onClick.listen((e) {
      if(togglable) {
        toggleSelection();
      }
    });
  }

  /**
   * The URL of an image for the icon.
   */
  @published String src = '';
  
  /**
   * The size of the icon button.
   */
  @published int size = 24;
  
  void sizeChanged() {
    print('sizeChanged size:${this.size}');
    
    this.style.width =  '${this.size}px';
    this.style.height = '${this.size}px';
  }
  
  /**
   * Sets if the icon button is togglable 
   */
  @published bool togglable = false;
  
  void togglableChange() {
    //TODO: debug to see if the value of toggable is updated?
    print('${togglable}');
    if(togglable) {
      
    } else {
      deselect();
    }
  }

  /**
   * If true, border is placed around the button to indicate
   * active state.
   */
  bool _selected = false;
  bool get selected => _selected;
  select() {
    if(togglable && _selected != true) {
      _selected = true;
      //TODO: return a event object?
      _selectionEC.add(this);
      this.classes.add('active');
    }
  }
  deselect() {
    if(togglable && _selected != false) {
      _selected = false;
      //TODO: return a event object?
      _deselectionEC.add(this);
      this.classes.remove('active');
    }
  }
  toggleSelection() {
    if(_selected) {
      deselect();
    } else {
      select();
    }
  }
  
  //events
  StreamController _selectionEC = new StreamController.broadcast();
  Stream get onButtonSelected => _selectionEC.stream;
  
  StreamController _deselectionEC = new StreamController.broadcast();
  Stream get onButtonDeselected => _deselectionEC.stream;
}
