part of dockable.dock;

//TODO: implement animation
//TODO: test setting custom widths
//TODO: fix: when the splitter is slided to max or min values, it creates a jerk to next container.
//TODO: sucks, improve weight calulation performance, splitter sliding performance, performLayout performance
//TODO: implement containers with locked splitters

@CustomTag('dockable-container')
class DockableContainer extends DockableContainerInterface {
  bool get isRoot  => _parentContainer == null;
  
  List<DockContainer> _nodes = new List<DockContainer>(); 
  List<DockableSplitter> _splitters = new List<DockableSplitter>();
  List<StreamSubscription> _splitterStreams = new List<StreamSubscription>(); 
  
  DockableContainer.created() : super.created() {
  }
  
  bool _commonDocker(DockContainer newContainer, DockContainer adjacantContainer, bool arg_horizontal, bool after) {
    int index = after ? _nodes.length : 0;
    if(adjacantContainer != null) {
      //if a adjacantContainer container is specified, find the index to insert
      if(_nodes.contains(adjacantContainer)) {
        index = after ? _nodes.indexOf(adjacantContainer) + 1 : _nodes.indexOf(adjacantContainer);
      } else {
        adjacantContainer = null;
      }
    }
    
    //if _nodes.length < 2 and _direction != arg_direction, change it to arg_direction
    if (_nodes.length < 2 || __vertical == arg_horizontal) {
      _vertical = arg_horizontal;
      if(_nodes.length == 0) {
        _holder.children.insert(0, newContainer);
        _nodes.insert(0, newContainer);
      } else {
          DockableSplitter splitter = new Element.tag('dockable-splitter');
          StreamSubscription splitterSlide = splitter.onSlide.listen(_slideWeights);
          
          splitter.vertical = !arg_horizontal;
          
          if(after && index == _nodes.length) {
            _holder.children.add(splitter);
            _holder.children.add(newContainer);
            _nodes.add(newContainer);
            _splitters.add(splitter);
            _splitterStreams.add(splitterSlide);
          } else {
            _holder.children.insert(2 * index, newContainer);
            _holder.children.insert((2 * index) + 1, splitter);
            _nodes.insert(index, newContainer);
            _splitters.insert(index, splitter);
            _splitterStreams.insert(index, splitterSlide);
          }
        }
        _newWeights(newContainer);
        newContainer._parentContainer = this;
        this.performLayout();
      } else {
        if(adjacantContainer == null && isRoot) {
          List<DockContainer> tNodes = new List<DockContainer>(); 
          for(DockContainer node in _nodes) {
            tNodes.add(node);
          }
          for(DockContainer node in tNodes) {
            unDock(node);
          }
          _vertical = arg_horizontal;
          DockableContainer tC = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          _commonDocker(tC, null, arg_horizontal, after);
          _commonDocker(newContainer, null, arg_horizontal, after);
          for(DockContainer node in tNodes) {
            tC._commonDocker(node, null, !arg_horizontal, true);
          }
          performLayout();
        } else {
          //TODO: what if its root?
          DockableContainer newCont = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          _replaceDock(adjacantContainer, newCont);
          newCont._commonDocker(adjacantContainer, null, arg_horizontal, after);
          newCont._commonDocker(newContainer, null, arg_horizontal, after);
          performLayout();
        }
      }
  }
  
  /*
   * Docks the provided newPanel to the left of the leftOf DockableContainer.
   * If leftOf is null or is not child in this DockableContainer, the newPanel is
   * docked to the left most position.
   */
  bool dockToLeft(DockContainer newContainer, [DockContainer leftOf]) {
    bool accepted = true;
    
    if(newContainer != null) {
      _commonDocker(newContainer, leftOf, true, false);
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  bool dockToRight(DockContainer newContainer, [DockContainer rightOf]) {
    bool accepted = true;
    
    if(newContainer != null) {
      _commonDocker(newContainer, rightOf, true, true);
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  bool dockToTop(DockContainer newContainer, [DockContainer topOf]) {
    bool accepted = true;
    
    if(newContainer != null) {
      _commonDocker(newContainer, topOf, false, false);
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  bool dockToBottom(DockContainer newContainer, [DockContainer bottomOf]) {
    bool accepted = true;
    
    if(newContainer != null) {
      _commonDocker(newContainer, bottomOf, false, true);
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  bool _replaceDock(DockContainer _oldPanel, DockContainer _newPanel) {
    bool accepted = true;
    if(_oldPanel != null && _newPanel != null) {
      int index = _nodes.indexOf(_oldPanel);
      if(index != -1) {
        if(_vertical == true) {
          dockToLeft(_newPanel, _oldPanel);
        } else {
          dockToTop(_newPanel, _oldPanel);
        }
        _oldPanel.unDockMe();
      } else {
        accepted = false;
      }
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  _removeContainerNode(DockContainer _newPanel) {
    int ind = _nodes.indexOf(_newPanel);
    DockableSplitter rmSplit = null;
    if(ind >= 0) {
      _nodes.remove(_newPanel);
      //if it is not the final container, remove the associated splitter
      if(ind < _nodes.length - 1) {
        rmSplit = _splitters.removeAt(ind);
        _splitterStreams.removeAt(ind).cancel();
      } else if(ind == _nodes.length - 1) {
        rmSplit = _splitters.removeLast();
        _splitterStreams.removeLast().cancel();
      }
    }
    if(_holder.children.contains(_newPanel)) {
      _holder.children.remove(_newPanel);
    }
    if(rmSplit != null) {
      _holder.children.remove(rmSplit);
    }
    _newPanel._parentContainer = null;
  }
  
  unDock(DockContainer _newPanel) {
    if(_nodes.length == 2) {
      //if we are going to be left with only one container after removing,
      //we remove self and attach the only left child to our parent.
      //This will remove uncessary Containers.
      _removeContainerNode(_newPanel);
      DockContainer onlyCon = _nodes.first;
      if(!isRoot) {
        _removeContainerNode(onlyCon);
        this._parentContainer._replaceDock(this, onlyCon);
        onlyCon.performLayout();
      } else {
        //_manager.replaceRoot(onlyCon);
        performLayout();
      }
    } else if(_nodes.length == 1) {
      //if the last element is being removed, remove itself
      _removeContainerNode(_newPanel);
      unDockMe();
    } else {
      _removeContainerNode(_newPanel);
      performLayout();
    }
  }
  
  unDockMe() {
    if(!isRoot) {
      _parentContainer.unDock(this);
    } else {
    }
  }
  
  performLayout() {
    if(isRoot == true) {
      //If it is the root, fill the parent
      /*this.style.width = "${this.parent.offsetWidth}px";
      this.style.height = "${this.parent.offsetHeight}px";*/
      this.style.width = "";
      this.style.height = "";
    }
    //Adjust the size of outdiv
    //this._outdiv.style.width = "${this.offsetWidth}px";
    //this._outdiv.style.height = "${this.offsetHeight}px";
    
    if(this._nodes.length != 0) {
      _calculateWeight();
      for(DockContainer node in _nodes) {
        if(this._vertical == true) {
          node.style.width = "";
          node.style.height = "auto";
          node.style.flex = "${node._calcweight}";
        } else {
          node.style.width = "auto";
          node.style.height = "";
          node.style.flex = "${node._calcweight}";
        }
        node.performLayout();
      }
    }
  }
  
  void enteredView() {
    //style init
    
    performLayout();
  }
  
  DivElement __holder;
  DivElement get _holder {
    if(__holder == null) {
      __holder = this.shadowRoot.querySelector(".holder");
      if(__holder == null) {
        print("Dockable->DockableContainer: outdiv cannot be null!");
        assert(false);
      }
    }
    return __holder;
  }
  
  /*************************weight*********************************/
  _newWeights(DockContainer _newCont) {
    //fix weights
    if(_newCont.weight == 0) {
      //For a new container, if the weight is 0, give it a fair weight
      _newCont.weight = 0.5;
    }
    _calculateWeight();
  }
  
  _slideWeights(DockableSplitterSlideEvent e) {
    int splitterInd = _splitters.indexOf(e.target);
    if(splitterInd >= 0 && splitterInd < _nodes.length - 1) {
      DockContainer tCont = _nodes[splitterInd];
      DockContainer tContNext = _nodes[splitterInd + 1];
      num deltaPer = 0;
      if(_vertical == true) {
        deltaPer = (e.offsetPos - (tCont.offsetLeft + tCont.offsetWidth) + _holder.offsetLeft)/_holder.offsetWidth;
        print('hori ${deltaPer} ${e.clientPos} ${tCont.offsetLeft} ${tCont.offsetWidth}');
      } else {
        deltaPer = (e.offsetPos - (tCont.offsetTop + tCont.offsetHeight) + _holder.offsetTop)/_holder.offsetHeight;
        print('vert ${deltaPer} ${e.clientPos} ${tCont.offsetLeft} ${tCont.offsetWidth}');
      }
      tCont.weight = tCont.weight + deltaPer;
      tContNext.weight = tContNext.weight - deltaPer;
      _calculateWeight();
      performLayout();
    }
  }
  
  //Calculate demanded weight
  _calculateWeight() {
    num total_weight = 0;
    //calculate total weights
    for(DockContainer child in _nodes) {
      total_weight += child.weight;
      //print('${child.ContainerName} ${child.weight}');
    }
    
    //if total weights don't add up to 1, normalize them
    for(DockContainer child in _nodes) {
      child._calcweight = child.weight/total_weight;
      //print('${child.ContainerName} ${child._calcweight}');
    }
  }
  
  void set _vertical(bool arg_vertical) {
    if(__vertical != arg_vertical) {
      if(arg_vertical) {
        _holder.classes.remove('vertical');
      } else {
        _holder.classes.add('vertical');
      }
      __vertical = arg_vertical;
    }
  }
}