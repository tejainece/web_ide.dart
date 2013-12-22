library dockable.container;
import 'package:polymer/polymer.dart';
import 'dart:html';
//import '../dock/dockable_manager.dart';
import '../splitter/dockable_splitter.dart';

//TODO: implement content
//TODO: implement animation
//TODO: test setting custom widths
//TODO: test insert right and bottom
//TODO: fix: when the splitter is slided to max or min values, it creates a jerk to next container.
//TODO: sucks, improve weight calulation performance, splitter sliding performance, performLayout performance

///Container implementation
@CustomTag('dockable-container')
class DockableContainer extends PolymerElement {
  bool get isRoot  => _parentContainer == null;
  
  DockableContainer _parentContainer;
  
  List<DockableContainer> _nodes = new List<DockableContainer>(); 
  List<DockableSplitter> _splitters = new List<DockableSplitter>(); 
  
  DockableContainer.created() : super.created() {
  }
  
  /******************************Content********************************/
  Element _content;
  bool dock(DockableContainer newContainer) {
    bool accepted = true;
    if(newContainer != null) {
      
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  /*
   * Docks the provided newPanel to the left of the leftOf DockableContainer.
   * If leftOf is null or is not child in this DockableContainer, the newPanel is
   * docked to the left most position.
   */
  bool dockToLeft(DockableContainer newPanel, [DockableContainer leftOf]) {
    bool accepted = true;
    
    int index = 0;
    if(leftOf != null) {
      //if a leftOf container is specified, find the index
      if(_nodes.contains(leftOf)) {
        index = _nodes.indexOf(leftOf);
      } else {
        leftOf = null;
      }
    }
    if(newPanel != null) {
      //if _direction == DOCKABLE_DIRECTION_FILL and _nodes.length < 2, convert it to DOCKABLE_DIRECTION_HORIZONTAL
      //if _nodes.length < 2 and _direction == DOCKABLE_DIRECTION_VERTICAL, change it to DOCKABLE_DIRECTION_HORIZONTAL
      if (_nodes.length < 2 || _direction == DOCKABLE_DIRECTION_HORIZONTAL) {
        _direction = DOCKABLE_DIRECTION_HORIZONTAL;
        _outdiv.style.flexFlow = "row";
        if(_nodes.length == 0) {
          _outdiv.children.insert(0, newPanel);
          _nodes.insert(0, newPanel);
        } else {
          DockableSplitter splitter = new Element.tag('dockable-splitter');
          //TODO: remove stream subscription
          splitter.onSlide.listen(_slideWeights);
          _outdiv.children.insert(2 * index, newPanel);
          _outdiv.children.insert((2 * index) + 1, splitter);
          _nodes.insert(index, newPanel);
          _splitters.insert(index, splitter);
        }
        _newWeights(newPanel);
        newPanel._parentContainer = this;
        this.performLayout();
      } else {
        if(leftOf == null && isRoot) {
          List<DockableContainer> tNodes = new List<DockableContainer>(); 
          for(DockableContainer node in _nodes) {
            tNodes.add(node);
          }
          for(DockableContainer node in tNodes) {
            unDock(node);
          }
          _direction = DOCKABLE_DIRECTION_HORIZONTAL;
          _outdiv.style.flexFlow = "row";
          DockableContainer tC = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          dockToLeft(tC);
          dockToLeft(newPanel);
          for(DockableContainer node in tNodes) {
            tC.dockToBottom(node);
          }
          performLayout();
        } else {
          DockableContainer newCont = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          _replaceDock(leftOf, newCont);
          newCont.dockToLeft(leftOf);
          newCont.dockToLeft(newPanel);
          performLayout();
        }
      }
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  bool dockToRight(DockableContainer newPanel, [DockableContainer rightOf]) {
    bool accepted = true;
    
    int index = _nodes.length - 1;
    if(rightOf != null) {
      //if a leftOf container is specified, find the index
      if(_nodes.contains(rightOf)) {
        index = _nodes.indexOf(rightOf);
      } else {
        rightOf = null;
      }
    }
    if(newPanel != null) {
      //if _direction == DOCKABLE_DIRECTION_FILL and _nodes.length < 2, convert it to DOCKABLE_DIRECTION_HORIZONTAL
      //if _nodes.length < 2 and _direction == DOCKABLE_DIRECTION_VERTICAL, change it to DOCKABLE_DIRECTION_HORIZONTAL
      if (_nodes.length < 2 || _direction == DOCKABLE_DIRECTION_HORIZONTAL) {
        _direction = DOCKABLE_DIRECTION_HORIZONTAL;
        _outdiv.style.flexFlow = "row";
        if(_nodes.length == 0) {
          _outdiv.children.insert(0, newPanel);
          _nodes.insert(0, newPanel);
        } else {
          DockableSplitter splitter = new Element.tag('dockable-splitter');
          //TODO: remove stream subscription
          splitter.onSlide.listen(_slideWeights);
          if(index == _nodes.length - 1) {
            _outdiv.children.add(splitter);
            _outdiv.children.add(newPanel);
            _nodes.add(newPanel);
            _splitters.add(splitter);
          } else {
            int insertIndex = index + 1;
            _outdiv.children.insert(2 * insertIndex, newPanel);
            _outdiv.children.insert((2 * insertIndex) + 1, splitter);
            _nodes.insert(insertIndex, newPanel);
            _splitters.insert(insertIndex, splitter);
          }
        }
        _newWeights(newPanel);
        newPanel._parentContainer = this;
        this.performLayout();
      } else {
        if(rightOf == null && isRoot) {
          List<DockableContainer> tNodes = new List<DockableContainer>(); 
          for(DockableContainer node in _nodes) {
            tNodes.add(node);
          }
          for(DockableContainer node in tNodes) {
            unDock(node);
          }
          _direction = DOCKABLE_DIRECTION_HORIZONTAL;
          _outdiv.style.flexFlow = "row";
          DockableContainer tC = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          dockToRight(tC);
          dockToRight(newPanel);
          for(DockableContainer node in tNodes) {
            tC.dockToBottom(node);
          }
          performLayout();
        } else {
          DockableContainer newCont = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          _replaceDock(rightOf, newCont);
          newCont.dockToRight(rightOf);
          newCont.dockToRight(newPanel);
          performLayout();
        }
      }
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  dockToTop(DockableContainer newPanel, [DockableContainer topOf]) {
    bool accepted = true;
    
    int index = 0;
    if(topOf != null) {
      //if a topOf container is specified, find the index
      if(_nodes.contains(topOf)) {
        index = _nodes.indexOf(topOf);
      } else {
        topOf = null;
      }
    }
    if(newPanel != null) {
      //if _direction == DOCKABLE_DIRECTION_FILL and _nodes.length < 2, convert it to DOCKABLE_DIRECTION_VERTICAL
      //if _nodes.length < 2 and _direction == DOCKABLE_DIRECTION_HORIZONTAL, change it to DOCKABLE_DIRECTION_VERTICAL
      if (_nodes.length < 2 || _direction == DOCKABLE_DIRECTION_VERTICAL) {
        _direction = DOCKABLE_DIRECTION_VERTICAL;
        _outdiv.style.flexFlow = "column";
        if(_nodes.length == 0) {
          _outdiv.children.insert(0, newPanel);
          _nodes.insert(0, newPanel);
        } else {
          DockableSplitter splitter = new Element.tag('dockable-splitter');
          //TODO: remove stream subscription
          splitter.onSlide.listen(_slideWeights);
          splitter.attributes["horizontal"] = 'true';
          
          _outdiv.children.insert(2 * index, newPanel);
          _outdiv.children.insert((2 * index) + 1, splitter);
          _nodes.insert(index, newPanel);
          _splitters.insert(index, splitter);
        }
        _newWeights(newPanel);
        newPanel._parentContainer = this;
        this.performLayout();
      } else {
        if(topOf == null && isRoot) {
          List<DockableContainer> tNodes = new List<DockableContainer>(); 
          for(DockableContainer node in _nodes) {
            tNodes.add(node);
          }
          for(DockableContainer node in tNodes) {
            unDock(node);
          }
          _direction = DOCKABLE_DIRECTION_VERTICAL;
          _outdiv.style.flexFlow = "column";
          DockableContainer tC = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          dockToTop(tC);
          dockToTop(newPanel);
          for(DockableContainer node in tNodes) {
            tC.dockToRight(node);
          }
          performLayout();
        } else {
          DockableContainer newCont = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          _replaceDock(topOf, newCont);
          newCont.dockToTop(topOf);
          newCont.dockToTop(newPanel);
          performLayout();
        }
      }
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  dockToBottom(DockableContainer newPanel, [DockableContainer bottomOf]) {
    bool accepted = true;
    
    int index = _nodes.length - 1;
    if(bottomOf != null) {
      //if a topOf container is specified, find the index
      if(_nodes.contains(bottomOf)) {
        index = _nodes.indexOf(bottomOf);
      } else {
        bottomOf = null;
      }
    }
    if(newPanel != null) {
      //if _direction == DOCKABLE_DIRECTION_FILL and _nodes.length < 2, convert it to DOCKABLE_DIRECTION_VERTICAL
      //if _nodes.length < 2 and _direction == DOCKABLE_DIRECTION_HORIZONTAL, change it to DOCKABLE_DIRECTION_VERTICAL
      if (_nodes.length < 2 || _direction == DOCKABLE_DIRECTION_VERTICAL) {
        _direction = DOCKABLE_DIRECTION_VERTICAL;
        _outdiv.style.flexFlow = "column";
        if(_nodes.length == 0) {
          _outdiv.children.insert(0, newPanel);
          _nodes.insert(0, newPanel);
        } else {
          DockableSplitter splitter = new Element.tag('dockable-splitter');
          //TODO: remove stream subscription
          splitter.onSlide.listen(_slideWeights);
          splitter.attributes["horizontal"] = 'true';
          if(index == _nodes.length - 1) {
            _outdiv.children.add(splitter);
            _outdiv.children.add(newPanel);
            _nodes.add(newPanel);
            _splitters.add(splitter);
          } else {
            int insertIndex = index + 1;
            _outdiv.children.insert(2 * insertIndex, newPanel);
            _outdiv.children.insert((2 * insertIndex) + 1, splitter);
            _nodes.insert(insertIndex, newPanel);
            _splitters.insert(insertIndex, splitter);
          }
        }
        _newWeights(newPanel);
        newPanel._parentContainer = this;
        performLayout();
      } else {
        if(bottomOf == null && isRoot) {
          List<DockableContainer> tNodes = new List<DockableContainer>(); 
          for(DockableContainer node in _nodes) {
            tNodes.add(node);
          }
          for(DockableContainer node in tNodes) {
            unDock(node);
          }
          _direction = DOCKABLE_DIRECTION_VERTICAL;
          _outdiv.style.flexFlow = "column";
          DockableContainer tC = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          dockToTop(tC);
          dockToTop(newPanel);
          for(DockableContainer node in tNodes) {
            tC.dockToRight(node);
          }
          performLayout();
        } else {
          DockableContainer newCont = new Element.tag('dockable-container');
          //TODO: adjust weights on all newly created DCs
          _replaceDock(bottomOf, newCont);
          newCont.dockToBottom(bottomOf);
          newCont.dockToBottom(newPanel);
          performLayout();
        }
      }
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  bool _replaceDock(DockableContainer _oldPanel, DockableContainer _newPanel) {
    bool accepted = true;
    if(_oldPanel != null && _newPanel != null) {
      int index = _nodes.indexOf(_oldPanel);
      if(index != -1) {
        if(direction == DOCKABLE_DIRECTION_HORIZONTAL) {
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
  
  _removeContainerNode(DockableContainer _newPanel) {
    int ind = _nodes.indexOf(_newPanel);
    DockableSplitter rmSplit = null;
    if(ind >= 0) {
      _nodes.remove(_newPanel);
      //if it is not the final container, remove the associates splitter
      if(ind < _nodes.length - 1) {
        //TODO: remove all stream subscription?
        rmSplit = _splitters.removeAt(ind);
      } else if(ind == _nodes.length - 1) {
        //TODO: remove all stream subscription?
        rmSplit = _splitters.removeLast();
      }
    }
    if(_outdiv.children.contains(_newPanel)) {
      _outdiv.children.remove(_newPanel);
    }
    if(rmSplit != null) {
      _outdiv.children.remove(rmSplit);
    }
    _newPanel._parentContainer = null;
  }
  
  unDock(DockableContainer _newPanel) {
    if(_nodes.length == 2) {
      //if we are going to be left with only one container after removing,
      //we remove self and attach the only left child to our parent.
      //This will remove uncessary Containers.
      _removeContainerNode(_newPanel);
      DockableContainer onlyCon = _nodes.first;
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
      this.style.width = "${this.parent.offsetWidth}px";
      this.style.height = "${this.parent.offsetHeight}px";
    }
    //Adjust the size of outdiv
    //this._outdiv.style.width = "${this.offsetWidth}px";
    //this._outdiv.style.height = "${this.offsetHeight}px";
    
    if(this._nodes.length != 0) {
      _calculateWeight();
      for(DockableContainer node in _nodes) {
        if(this.direction == DOCKABLE_DIRECTION_HORIZONTAL) {
          node.style.width = "auto";
          node.style.height = "auto";
          node.style.flex = "${node._calcweight}";
        } else if(this.direction == DOCKABLE_DIRECTION_VERTICAL) {
          node.style.width = "auto";
          node.style.height = "auto";
          node.style.flex = "${node._calcweight}";
        } else {
          print('Dockable->Container->PerformLayout: Unsupported direction');
          assert(false);
        }
        node.performLayout();
      }
    }
  }
  
  void enteredView() {
    //style init
    style.flexFlow = "row";
    _outdiv.style.flexGrow = "1";
    
    performLayout();
  }
  
  DivElement __outdiv;
  DivElement get _outdiv {
    if(__outdiv == null) {
      __outdiv = this.shadowRoot.querySelector(".dockable-container-outdiv");
      if(__outdiv == null) {
        print("Dockable->DockableContainer: outdiv cannot be null!");
        assert(false);
      }
    }
    return __outdiv;
  }
  
  /*
   * Specifies the direction of the container.
   */
  String _direction = DOCKABLE_DIRECTION_FILL;
  String get direction => _direction;
  static const DOCKABLE_DIRECTION_FILL = "fill";
  static const DOCKABLE_DIRECTION_HORIZONTAL = "horizontal";
  static const DOCKABLE_DIRECTION_VERTICAL = "vertical";
  
  String _ContainerName = "";
  set ContainerName(String arg_name) {
    if(arg_name != null) {
      _ContainerName = arg_name;
    } else {
      _ContainerName = "";
    }
  }
  String get ContainerName {
    return _ContainerName;
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
  
  _newWeights(DockableContainer _newCont) {
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
      DockableContainer tCont = _nodes[splitterInd];
      DockableContainer tContNext = _nodes[splitterInd + 1];
      num deltaPer = 0;
      if(direction == DOCKABLE_DIRECTION_HORIZONTAL) {
        deltaPer = (e.offsetPos - (tCont.offsetLeft + tCont.offsetWidth) + _outdiv.offsetLeft)/_outdiv.offsetWidth;
        //print('${tCont.ContainerName} ${deltaPer} ${e.clientPos} ${tCont.offsetLeft} ${tCont.offsetWidth} ${_outdiv.offsetWidth}');
      } else if(direction == DOCKABLE_DIRECTION_VERTICAL) {
        deltaPer = (e.offsetPos - (tCont.offsetTop + tCont.offsetHeight) + _outdiv.offsetTop)/_outdiv.offsetHeight;
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
    //print('before normalizing');
    for(DockableContainer child in _nodes) {
      total_weight += child.weight;
      //print('${child.ContainerName} ${child.weight}');
    }
    
    //print('normalizing');
    //if total weights don't add up to 1, normalize them
    for(DockableContainer child in _nodes) {
      child._calcweight = child.weight/total_weight;
      //print('${child.ContainerName} ${child._calcweight}');
    }
  }
}