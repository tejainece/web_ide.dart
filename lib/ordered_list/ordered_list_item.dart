part of ordered_list;

/**
 * A Polymer click counter element.
 */
@CustomTag('ordered-list-item')
class OrderedListItem extends PolymerElement {
  /*
   * Set to true to prevent disposal of observable bindings
   */
  bool get preventDispose => true;

  Object _old_data;

  @published Object data;

  void dataChanged() {
    if (data != _old_data) {
      _register_changes();
    }
    _old_data = data;
  }

  @published
  ObservableList<String> fields = new ObservableList<String>();

  void fieldsChanged() {
    notifyPropertyChange(#heading, "", data.toString());
  }

  @published
  String get heading {
    String ret = null;
    if (fields != null && fields.length != 0) {
      try {
        Symbol s = smoke.nameToSymbol(fields[0]);
        ret = smoke.read(data, s);
      } catch (e) {
      }
    }
    if (ret == null) {
      if(data != null) {
        ret = data.toString();
      } else {
        ret = "";
      }
    }
    return ret;
  }

  OrderedListItem.created() : super.created() {
  }

  @override
  void attached() {
    _register_changes();
    if(data != null) {
      notifyPropertyChange(#heading, "", data.toString());
    }
  }

  @override
  void detached() {
    if (_changes_ss != null) {
      _changes_ss.cancel();
      _changes_ss = null;
    }
  }

  void _register_changes() {
    if (data != null) {
      if (_changes_ss != null) {
        _changes_ss.cancel();
        _changes_ss = null;
      }
      if (data is Observable) {
        Observable _d = data;
        _changes_ss = _d.changes.listen((crec) {
          notifyPropertyChange(#heading, "", data.toString());
        });
      }
    }
  }

  StreamSubscription _changes_ss;
}
