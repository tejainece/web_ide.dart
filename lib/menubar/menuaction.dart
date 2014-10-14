part of menubar;

class MenuAction extends ChangeNotifier {
  
  MenuAction(String lab, this.action, this.icon) {
    label = lab;
  }
  
  String _label;
  String get label => _label;
  set label(String lab) {
    _label = notifyPropertyChange(#label, _label, lab);
  }
  
  Function action;
  
  String icon;
}