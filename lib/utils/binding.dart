part of dockable_utils;

dynamic getModelForItem(item) {
  dynamic ret = nodeBind(item).templateInstance.model.model;

  return ret;
}
