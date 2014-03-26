part of docker;

abstract class DockContainerBase extends PolymerElement {

  DockableContainerIF _parentContainer;

  DockContainerBase.created() : super.created() {
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

abstract class DockableContainerIF extends DockContainerBase {
  DockableContainerIF.created() : super.created() {
  }

  bool dockToLeft(DockContainerBase newPanel, [DockContainerBase leftOf]);
  bool dockToRight(DockContainerBase newPanel, [DockContainerBase rightOf]);
  bool dockToTop(DockContainerBase newPanel, [DockContainerBase topOf]);
  bool dockToBottom(DockContainerBase newPanel, [DockContainerBase bottomOf]);

  bool _replaceDock(DockContainerBase _oldPanel, DockContainerBase _newPanel);

  unDock(DockContainerBase _newPanel);

  /*
   * Specifies the direction of the container.
   */
  @published bool vertical;
}