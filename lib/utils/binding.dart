part of dockable_utils;

dynamic getModelForItem(item) {
  TemplateInstance l_tempinst = nodeBind(item).templateInstance;
  if(l_tempinst != null) {
    return l_tempinst.model.model;
  } else {
    return null;
  }
}
