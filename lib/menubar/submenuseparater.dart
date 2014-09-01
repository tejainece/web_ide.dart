part of menubar;

@CustomTag('submenu-separater-item')
class SubMenuSeparaterItem extends SubMenuItemBase {
  SubMenuSeparaterItem.created() : super.created() {
  }
  
  @override
  void attached() {
    super.attached();
    for(Element _el in this.children) {
      _el.remove();
    }
  }
}