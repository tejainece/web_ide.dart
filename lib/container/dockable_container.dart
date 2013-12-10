library dockable.container;
import 'package:polymer/polymer.dart';
import 'dart:html';
import '../dock/dockable_manager.dart';
import '../splitter/dockable_splitter.dart';

///Container implementation
@CustomTag('dockable-container')
class DockableContainer extends PolymerElement {
  bool get isRoot  => _manager != null;
  //TODO: can we improve this and avoid circular dependency?
  DockableManager _manager;
  setRoot(DockableManager arg_manager) {
    if(arg_manager != null) {
      _manager = arg_manager;
      _parentContainer = null;
    } else {
      print("Dockable->Container->SetRoot: Cannot set null root.");
      assert(false);
    }
  }
  removeRoot() {
    if(isRoot) {
      _manager = null;
      _parentContainer = null;
    } else {
      print("Dockable->Container->RemoveRoot: Not a root.");
      assert(false);
    }
  }
  
  DockableContainer _parentContainer;
  
  List<DockableContainer> _nodes = new List<DockableContainer>(); 
  List<DockableSplitter> _splitters = new List<DockableSplitter>(); 
  
  DockableContainer.created() : super.created() {
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
      }
    }
    
    if(newPanel != null) {
      //TODO: handle DOCKABLE_DIRECTION_FILL
      //TODO: if _direction == DOCKABLE_DIRECTION_FILL and _nodes.length < 2, convert it to DOCKABLE_DIRECTION_HORIZONTAL
      //TODO: what if _nodes.length < 2 and _direction == DOCKABLE_DIRECTION_VERTICAL
      if (_nodes.length < 2 || _direction == DOCKABLE_DIRECTION_HORIZONTAL) {
        
        _direction = DOCKABLE_DIRECTION_HORIZONTAL;
        _outdiv.style.flexFlow = "row";
        if(_nodes.length == 0) {
          _outdiv.children.insert(0, newPanel);
          _nodes.insert(0, newPanel);
        } else if(index == 0) {
          DockableSplitter splitter = new Element.tag('dockable-splitter');
          //TODO: remove stream subscription
          splitter.onSlide.listen(_slideWeights);
          
          _outdiv.children.insert(0, newPanel);
          _outdiv.children.insert(1, splitter);
          _nodes.insert(0, newPanel);
          _splitters.insert(index, splitter);
        } else {
          DockableSplitter splitter = new Element.tag('dockable-splitter');
          //TODO: remove stream subscription
          splitter.onSlide.listen(_slideWeights);
          
          _outdiv.children.insert(index, newPanel);
          _outdiv.children.insert(index + 1, splitter);
          _nodes.insert(index, newPanel);
          _splitters.insert(index, splitter);
        }
        
        
        _newWeights(newPanel);
        newPanel._parentContainer = this;
        
        this.performLayout();
      } else {
        if(isRoot) {
          print("Dockable->Container->dockLeft: Cannot displace root container.");
          assert(false);
        } else {
          //TODO: implement leftof
          DockableContainer newCont = new Element.tag('dockable-container');
          _parentContainer.replaceDock(this, newCont);
          newCont.dockToLeft(this);
          newCont.dockToLeft(newPanel);
          
          newCont.performLayout();
        }
      }
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  dockToTop(DockableContainer _newPanel, [DockableContainer topOf]) {
    bool accepted = true;
    if(_newPanel != null) {
      if (_nodes.length < 2 || _direction == DOCKABLE_DIRECTION_VERTICAL) {
        int index = 0;
        if(topOf != null && _nodes.contains(topOf)) {
          index = _nodes.indexOf(topOf);
        }
        _direction = DOCKABLE_DIRECTION_VERTICAL;
        _outdiv.style.flexFlow = "column";
        _nodes.add(_newPanel);
        _outdiv.children.insert(index, _newPanel);
        _newPanel._parentContainer = this;
        this.performLayout();
      } else {
        if(isRoot) {
          print("Dockable->Container->dockTop: Cannot displace root container.");
          assert(false);
        } else {
          DockableContainer newCont = new Element.tag('dockable-container');
          _parentContainer.replaceDock(this, newCont);
          newCont.dockToTop(this);
          newCont.dockToTop(_newPanel);
          
          newCont.performLayout();
        }
      }
    } else {
      accepted = false;
    }
    return accepted;
  }
  
  bool replaceDock(DockableContainer _oldPanel, DockableContainer _newPanel) {
    bool accepted = true;
    if(_oldPanel != null && _newPanel != null) {
      int index = _nodes.indexOf(_oldPanel);
      if(index != -1) {
        _nodes.insert(index, _newPanel);
        _oldPanel.replaceWith(_newPanel);
        _removeContainerNode(_oldPanel);
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
    if(ind >= 0) {
      _nodes.remove(_newPanel);
      //if it is not the final container, remove the associates splitter
      if(ind != _nodes.length - 1) {
        //TODO: remove all stream subscription?
        _splitters.removeAt(ind);
      }
    }
    if(_outdiv.children.contains(_newPanel)) {
      _outdiv.children.remove(_newPanel);
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
      _removeContainerNode(onlyCon);
      if(!isRoot) {
        this._parentContainer.replaceDock(this, onlyCon);
      } else {
        _manager.replaceRoot(onlyCon);
      }
      onlyCon.performLayout();
    } else if(_nodes.length == 1) {
      //if the last element is being removed, remove itself
      unDockMe();
      _removeContainerNode(_newPanel);
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
    //print('${this.parent.offsetWidth} ${this.parent.offsetHeight}');
    if(isRoot == true && this.parent != null) {
      //If it is the root, fill the parent
      this.style.width = "${this.parent.offsetWidth}px";
      this.style.height = "${this.parent.offsetHeight}px";
    }
    //Adjust the size of outdiv
    this._outdiv.style.width = "${this.offsetWidth}px";
    this._outdiv.style.height = "${this.offsetHeight}px";
    
    if(this._nodes.length != 0) {
      _calculateWeight();
      for(DockableContainer node in _nodes) {
        if(this.direction == DOCKABLE_DIRECTION_HORIZONTAL) {
          node.style.width = "";
          node.style.height = "${this._outdiv.offsetHeight}px";
          node.style.flex = "${node.weight}";
        } else if(this.direction == DOCKABLE_DIRECTION_VERTICAL) {
          //TODO: implement weights
          node.style.width = "${this._outdiv.offsetWidth}px";
          node.style.height = "";
          node.style.flex = "1";
        } else {
          print('Dockable->Container->PerformLayout: Unsupported direction');
          assert(false);
        }
        node.performLayout();
      }
    }
  }
  
  void enteredView() {
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
  String _direction = "none";
  String get direction => _direction;
  static const DOCKABLE_DIRECTION_HORIZONTAL = "horizontal";
  static const DOCKABLE_DIRECTION_VERTICAL = "vertical";
  static const DOCKABLE_DIRECTION_FILL = "fill";
  
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
      num myNewWeight = 0;
      num nextsNewWeight = 0;
      if(direction == DOCKABLE_DIRECTION_HORIZONTAL) {
        num deltaPer = (e.offsetPos - (tCont.offsetLeft + tCont.offsetWidth) + _outdiv.offsetLeft)/_outdiv.offsetWidth;
        print('${tCont.ContainerName} ${deltaPer} ${e.clientPos} ${tCont.offsetLeft} ${tCont.offsetWidth} ${_outdiv.offsetWidth}');
        myNewWeight = tCont.weight + deltaPer;
        nextsNewWeight = tContNext.weight - deltaPer;
      } else if(direction == DOCKABLE_DIRECTION_VERTICAL) {
        //TODO: replicate what is done for horizontal
      }
      
      /*if(weight <= 0.0){
        weight = 0.001;
      } else if (weight >= 1.0) {
        weight = 1.0;
      }*/
      tCont.weight = myNewWeight;
      tContNext.weight = nextsNewWeight;
      _calculateWeight();
      performLayout();
    }
  }
  
  //Calculate demanded weight
  _calculateWeight() {
    num total_weight = 0;
    int fare_children = 0;
    //calculate total weights
    print('before normalizing');
    for(DockableContainer child in _nodes) {
      total_weight += child.weight;
      print('${child.ContainerName} ${child.weight}');
    }
    
    if(total_weight != 1.0) {
      print('normalizing');
      //if total weights don't add up to 1, normalize them
      for(DockableContainer child in _nodes) {
        child.weight = child.weight/total_weight;
        print('${child.ContainerName} ${child.weight}');
      }
    }
  }
  
  /******************************Content********************************/
  Element _content;
  setContent(Element arg_content) {
    if(arg_content != null) {
      _content = arg_content;
      
    } else {
      print("Dockable->Container->setContent: Cannot set null content");
      assert(false);
    }
  }
}