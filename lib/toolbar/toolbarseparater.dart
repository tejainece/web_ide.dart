part of toolbar;

/*
 * TODO:
 * Implementation:
 * 1) Is not created properly from HTML
 */

@CustomTag('toolbar-separater-item')
class ToolbarSeparater extends ToolbarItem {
  ToolbarSeparater.created() : super.created();

  @override
  void polymerCreated() {
    super.polymerCreated();
  }

  @override
  void set _size(int new_size) {
  }
}