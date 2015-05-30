@HtmlImport('dropdown.html')
library ancient_wars.elements.dropdown;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

import "package:template_binding/template_binding.dart"
    show nodeBind, templateBind, Scope, TemplateInstance;

import 'package:core_elements/core_icon.dart';

part 'dropdown_model.dart';

@CustomTag('drop-down')
class DropDown extends PolymerElement {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  DropDown.created() : super.created() {}

  TemplateElement _template;

  @observable
  ObservableList<DropdownModel> models = new ObservableList<DropdownModel>();

  Map<dynamic, DropdownModel> _modelsMap = new Map<dynamic, DropdownModel>();

  @published
  dynamic get selectedItem {
    if (selectedModel != null) {
      return selectedModel.item;
    } else {
      return null;
    }
  }

  set selectedItem(dynamic a_item) {
    selectItem(a_item);
  }

  @published
  DropdownModel selectedModel;

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
  ObservableList items = new ObservableList();

  void itemsChanged() {
    TemplateElement templ = this.querySelector("template");
    if (templ != null) {
      templ.attributes["repeat"] = '';

      Map<dynamic, DropdownModel> l_temp_modelsmap =
          new Map<dynamic, DropdownModel>();
      l_temp_modelsmap.addAll(_modelsMap);

      DropdownModel l_temp_selmod;

      models.clear();
      _modelsMap.clear();

      int index = 0;
      if (items != null) {
        for (var datael in items) {
          DropdownModel el = l_temp_modelsmap[datael];
          if (el == null) {
            el = new DropdownModel._(this, index++, datael);
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

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void ready() {
    super.ready();

    _thisObserver = new MutationObserver(_onThisMutation);
    _thisObserver.observe(this, childList: true);
  }

  MutationObserver _thisObserver;
  Map<Element, StreamSubscription> _streams =
      new Map<Element, StreamSubscription>();
  void _onThisMutation(records, observer) {
    //dataChanged();
    for (MutationRecord record in records) {
      for (Node node in record.addedNodes) {
        if (node is HtmlElement && node.attributes["dropdownitem"] != null) {
          _streams[node] = node.onClick.listen((Mouse) {
            DropdownModel l_model = DropdownModel.GetModelForElement(node);
            selectModel(l_model);
          });
        }
      }
      for (Node node in record.removedNodes) {
        if (node is HtmlElement && _streams[node] != null) {
          _streams.remove(node).cancel();
        }
      }
    }
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

  void selectModel(DropdownModel a_modsel) {
    if (!items.contains(a_modsel.item) ||
        _modelsMap[a_modsel.item] == null ||
        _modelsMap[a_modsel.item] != a_modsel) {
      return;
    }

    DropdownModel l_old = selectedModel;

    selectedModel = a_modsel;

    if (l_old != null) {
      l_old.notifySelected(true);
    }
    selectedModel.notifySelected(false);
  }

  void selectItem(dynamic a_sel) {
    DropdownModel l_mod = _modelsMap[a_sel];
    if (l_mod != null) {
      selectModel(l_mod);
    }
  }

  void deselectModel(DropdownModel a_modsel) {
    if (!items.contains(a_modsel.item) ||
        _modelsMap[a_modsel.item] == null ||
        _modelsMap[a_modsel.item] != a_modsel) {
      return;
    }

    if (!atleastone && selectedModel == a_modsel) {
      selectedModel = null;
      a_modsel.notifySelected(true);
    }
  }

  void deselectItem(dynamic a_sel) {
    DropdownModel l_mod = _modelsMap[a_sel];
    if (l_mod != null) {
      deselectModel(l_mod);
    }
  }

  void toggleModel(DropdownModel a_modsel) {
    if (!items.contains(a_modsel.item) ||
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

  void toggleItem(dynamic a_sel) {
    DropdownModel l_mod = _modelsMap[a_sel];
    if (l_mod != null) {
      toggleModel(l_mod);
    }
  }

  @observable
  bool open = false;

  void openChanged() {
    if (open) {
      classes.add("dd-opened");

      if (_hideClickStream == null) {
        new Timer(new Duration(milliseconds: 500), () {
          if (_hideClickStream == null) {
            _hideClickStream = document.body.onClick
                .listen((MouseEvent a_event) {
              open = false;
            });
          }
        });
      }
    } else {
      classes.remove("dd-opened");

      if (_hideClickStream != null) {
        _hideClickStream.cancel();
        _hideClickStream = null;
      }
    }
  }

  StreamSubscription _hideClickStream;
  void show() {
    open = true;
  }

  void hide() {
    open = false;
  }

  void toggle() {
    open = !open;
  }
}
