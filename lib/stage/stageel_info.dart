part of dockable.stage;

class StageElInfo {
  StageElement element;
  
  /**
   * Position of the stage element before move started
   */
  Point posBeforeMove;
  
  StreamSubscription movedStream;
  StreamSubscription resizedStream;
}