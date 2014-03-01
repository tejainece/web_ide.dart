library stage;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'dart:async';

/**
 * dock-stage is a stage used to create GUI interfaces like XCode Storyboard.
 *
 *     <dockable-icon width="720" height="480"></dockable-icon>
 *
 * @class dock-stage
 */
@CustomTag('dock-stage')
class DockStage extends PolymerElement {
  DockStage.created() : super.created() {
    _logger.finest('created');
  }

  final _logger = new Logger('Dockable.ColorPicker');
      
  @override 
  void polymerCreated() {
    _logger.finest('polymerCreated');
    super.polymerCreated();
  }
  
  @override
  void ready() {
    super.ready();
  }
  
  /*
   * Properties
   */  
  @published num scale = 1.0;
  
  @published bool resizable = true;
  
  void widthChanged() {
    
  }
  
  void heightChanged() {
    
  }
  
  void scaleChanged() {
    
  }
  
  void resizableChanged() {
    
  }
}
