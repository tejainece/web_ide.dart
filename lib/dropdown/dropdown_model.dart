part of ancient_wars.elements.dropdown;

class DropdownModel extends Observable {
  @observable
  int index;

  @observable
  bool get selected {
    if (_listbox != null) {
      return _listbox.selectedModel == this;
    } else {
      return false;
    }
  }

  void notifySelected(bool previous) {
    notifyPropertyChange(#selected, previous, selected);
  }

  @observable
  var item;

  DropDown _listbox;

  DropDown get listbox => _listbox;

  DropdownModel._(this._listbox, this.index, this.item) {}

  void select() {
    if (listbox != null && !selected) {
      listbox.selectModel(this);
    }
  }

  void deselect() {
    if (listbox != null && selected) {
      listbox.deselectModel(this);
    }
  }

  void toggle() {
    if (listbox != null) {
      listbox.toggleModel(this);
    }
  }
  
  static DropdownModel GetModelForElement(Element a_element) {
    TemplateInstance l_tempinst = nodeBind(a_element).templateInstance;
    if(l_tempinst != null && l_tempinst.model.model is DropdownModel) {
      return l_tempinst.model.model;
    } else {
      return null;
    }
  }

  static dynamic GetItemForElement(Element a_element) {
    TemplateInstance l_tempinst = nodeBind(a_element).templateInstance;
    if(l_tempinst != null) {
      if(l_tempinst.model is DropdownModel) {
        return l_tempinst.model.item;
      } else {
        return l_tempinst.model.model.item;
      }
    } else {
      return null;
    }
  }
}