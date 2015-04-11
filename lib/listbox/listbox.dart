@HtmlImport('listbox.html')
library listbox;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import 'package:dockable/dockable.dart';

import "package:template_binding/template_binding.dart"
    show nodeBind, templateBind, Scope;

class ListBoxModel extends Observable {
  @observable
  int index;

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

  ListBox _listbox;

  ListBox get listbox => _listbox;

  ListBoxModel._(this._listbox, this.index, this.item) {}

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
}

@CustomTag('list-box')
class ListBox extends PolymerElement {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  TemplateElement _template;

  @observable
  ObservableList<ListBoxModel> models = new ObservableList<ListBoxModel>();

  Map<dynamic, ListBoxModel> _modelsMap = new Map<dynamic, ListBoxModel>();

  @published
  dynamic get selectedItem {
    if (selectedModel != null) {
      return selectedModel.item;
    } else {
      return null;
    }
  }

  set selectedItem(dynamic a_item) {
    select(a_item);
  }

  @published
  ListBoxModel selectedModel;

  void selectedModelChanged() {
    notifyPropertyChange(#selectedItem, null, selectedItem);
    notifyPropertyChange(#selectedIndex, -1, selectedIndex);
  }

  @published
  int get selectedIndex {
    if (selectedModel != null) {
      return selectedModel.index;
    } else {
      return -1;
    }
  }

  set selectedIndex(int a_selind) {
    if (a_selind >= 0 && a_selind < models.length) {
      selectModel(models[a_selind]);
    }
  }

  @published
  ObservableList data = new ObservableList();

  void dataChanged() {
    TemplateElement templ = this.querySelector("template");
    if (templ != null) {
      templ.attributes["repeat"] = '';

      Map<dynamic, ListBoxModel> l_temp_modelsmap =
          new Map<dynamic, ListBoxModel>();
      l_temp_modelsmap.addAll(_modelsMap);

      ListBoxModel l_temp_selmod;

      models.clear();
      _modelsMap.clear();

      int index = 0;
      if (data != null) {
        for (var datael in data) {
          ListBoxModel el = l_temp_modelsmap[datael];
          if (el == null) {
            el = new ListBoxModel._(this, index++, datael);
          } else {
            el.index = index++;
            if (l_temp_selmod == null && selectedModel == el) {
              l_temp_selmod = selectedModel;
            }
          }
          models.add(el);
          _modelsMap[datael] = el;
        }
      }

      selectedModel = l_temp_selmod;
      templateBind(templ).model = models;
    }
  }

  ListBox.created() : super.created() {}

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();
  }

  @published
  bool atleastone = false;

  @override
  attached() {
    _template = querySelector("template");
    // Make sure they supplied a template in the content.
    if (_template == null) {
      throw '\n\nIt looks like you are missing the <template> '
          'tag in your <core-list-dart> content.';
    }
    if (templateBind(_template).bindingDelegate == null) {
      templateBind(_template).bindingDelegate = element.syntax;
    }
  }

  void selectModel(ListBoxModel a_modsel) {
    if (!data.contains(a_modsel.item) ||
        _modelsMap[a_modsel.item] == null ||
        _modelsMap[a_modsel.item] != a_modsel) {
      return;
    }

    ListBoxModel l_old = selectedModel;

    selectedModel = a_modsel;

    if (l_old != null) {
      l_old.notifySelected(true);
    }
    selectedModel.notifySelected(false);
  }

  void select(dynamic a_sel) {
    ListBoxModel l_mod = _modelsMap[a_sel];
    if (l_mod != null) {
      selectModel(l_mod);
    }
  }

  void deselectModel(ListBoxModel a_modsel) {
    if (!data.contains(a_modsel.item) ||
        _modelsMap[a_modsel.item] == null ||
        _modelsMap[a_modsel.item] != a_modsel) {
      return;
    }

    if (!atleastone && selectedModel == a_modsel) {
      selectedModel = null;
      a_modsel.notifySelected(true);
    }
  }

  void deselect(dynamic a_sel) {
    ListBoxModel l_mod = _modelsMap[a_sel];
    if (l_mod != null) {
      deselectModel(l_mod);
    }
  }

  void toggleModel(ListBoxModel a_modsel) {
    if (!data.contains(a_modsel.item) ||
        _modelsMap[a_modsel.item] == null ||
        _modelsMap[a_modsel.item] != a_modsel) {
      return;
    }

    if (a_modsel.selected) {
      deselectModel(a_modsel);
    } else {
      selectModel(a_modsel);
    }
  }

  void toggle(dynamic a_sel) {
    ListBoxModel l_mod = _modelsMap[a_sel];
    if (l_mod != null) {
      toggleModel(l_mod);
    }
  }
}
