part of dockable_utils;

dynamic getModelForItem(item) {
  dynamic ret = nodeBind(item).templateInstance.model;

  InstanceMirror im = reflect(ret);

  if (im.type.simpleName.toString() == 'Symbol("_GlobalsScope")') {
    ret = ret.model;
  } else if (im.type.simpleName.toString() == 'Symbol("_LocalVariableScope")') {
    //TODO:
  }

  return ret;
}
