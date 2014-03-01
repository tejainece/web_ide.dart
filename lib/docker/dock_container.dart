part of docker;

abstract class DockContainer extends PolymerElement {
  
  DockableContainerInterface _parentContainer;
  
  DockContainer.created() : super.created() {
  }
  
  /*************************weight*********************************/
  /*
   * Specifies the required weight of the container in this parent.
   * Weight of 0 means flexible and fare.
   */
  num _weight = 0;
  num get weight => _weight;
  set weight(num arg_weight) {
    //should be >= 0 and <= 1
    if(arg_weight >= 0 && arg_weight <= 1) {
      _weight = arg_weight;
    }
  }
  
  num __calcweight = 0;
  num get _calcweight => __calcweight;
  set _calcweight(num arg_weight) {
    //should be >= 0 and <= 1
    if(arg_weight >= 0 && arg_weight <= 1) {
      __calcweight = arg_weight;
    }
  }
  
  void performLayout();
  
  unDockMe();
}

abstract class DockableContainerInterface extends DockContainer {
  DockableContainerInterface.created() : super.created() {
  }
  
  bool dockToLeft(DockContainer newPanel, [DockContainer leftOf]);
  bool dockToRight(DockContainer newPanel, [DockContainer rightOf]);
  bool dockToTop(DockContainer newPanel, [DockContainer topOf]);
  bool dockToBottom(DockContainer newPanel, [DockContainer bottomOf]);
  
  bool _replaceDock(DockContainer _oldPanel, DockContainer _newPanel);
  
  unDock(DockContainer _newPanel);
  
  /*
   * Specifies the direction of the container.
   */
  @published bool vertical;
  /*bool __vertical = true;
  bool get _vertical => __vertical;
  void set _vertical(bool arg_direction) {
    if(arg_direction != null) {
      __vertical = arg_direction;
    }
  }*/
}