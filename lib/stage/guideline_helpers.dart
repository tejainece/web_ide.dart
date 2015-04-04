part of dockable.stage;


int detectHorMiddleGL(Rectangle rect, int a_width, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int ret;

  int lmiddle = rect.left + (rect.width ~/ 2);
  if (lmiddle == a_width ~/ 2) {
    ret = lmiddle;
  }
  for (StageElement b_elem in a_elements) {
    if (!a_selEls.contains(b_elem)) {
      int elmid = b_elem.offset.left + (b_elem.offsetWidth ~/ 2);
      if (lmiddle == elmid) {
        ret = lmiddle;
      }
    }
  }

  return ret;
}

int detectLeftGL(Rectangle rect, int a_width, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int ret;

  if (rect.left == 0) {
    ret = rect.left;
  } else if (rect.left == a_width) {
    ret = rect.left;
  }
  for (StageElement _elem in a_elements) {
    if (!a_selEls.contains(_elem)) {
      if (rect.left == _elem.offsetLeft) {
        ret = rect.left;
      } else if (rect.left == _elem.offset.right) {
        ret = rect.left;
      }
    }
  }

  return ret;
}

int detectRightGL(Rectangle rect, int a_width, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int ret;

  if (rect.right == 0) {
    ret = rect.right;
  } else if (rect.right == a_width) {
    ret = rect.right;
  }
  for (StageElement _elem in a_elements) {
    if (!a_selEls.contains(_elem)) {
      if (rect.right == _elem.offset.right) {
        ret = rect.right;
      } else if (rect.right == _elem.offset.left) {
        ret = rect.right;
      }
    }
  }

  return ret;
}

int detectVerMiddleGL(Rectangle rect, int a_height, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int ret;

  int tmiddle = rect.top + (rect.height ~/ 2);
  if (tmiddle == a_height ~/ 2) {
    ret = tmiddle;
  }
  for (StageElement _elem in a_elements) {
    if (!a_selEls.contains(_elem)) {
      int elmid = _elem.offset.top + (_elem.offsetHeight ~/ 2);
      if (tmiddle == elmid) {
        ret = tmiddle;
      }
    }
  }

  return ret;
}

int detectTopGL(Rectangle rect, int a_height, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int ret;

  if (rect.top == 0) {
    ret = rect.top;
  } else if (rect.top == a_height) {
    ret = rect.top;
  }
  for (StageElement _elem in a_elements) {
    if (!a_selEls.contains(_elem)) {
      if (rect.top == _elem.offsetTop) {
        ret = rect.top;
      } else if (rect.top == _elem.offset.bottom) {
        ret = rect.top;
      }
    }
  }

  return ret;
}

int detectBottomGL(Rectangle rect, int a_height, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int ret;

  if (rect.bottom == 0) {
    ret = rect.bottom;
  } else if (rect.bottom == a_height) {
    ret = rect.bottom;
  }
  for (StageElement _elem in a_elements) {
    if (!a_selEls.contains(_elem)) {
      if (rect.bottom == _elem.offset.bottom) {
        ret = rect.bottom;
      } else if (rect.bottom == _elem.offset.top) {
        ret = rect.bottom;
      }
    }
  }

  return ret;
}

Point detectMoveAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int vertAnchor;
  int horAnchor;
  //TODO: also find equal gaps

  //Vertical guideline
  vertAnchor = detectHorMiddleGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);

  if (vertAnchor == null) {
    vertAnchor = detectLeftGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);
  }

  if (vertAnchor == null) {
    vertAnchor = detectRightGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);
  }

  
  //Horizontal guideline
  horAnchor = detectVerMiddleGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);

  if (horAnchor == null) {
    horAnchor = detectTopGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);
  }

  if (horAnchor == null) {
    horAnchor = detectBottomGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);
  }

  return new Point(vertAnchor, horAnchor);
}

Point detectResizeNWAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int verAnchor;
  int horAnchor;
  //TODO: also find equal gaps

  verAnchor = detectHorMiddleGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);

  if (verAnchor == null) {
    verAnchor = detectLeftGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);
  }

  horAnchor = detectVerMiddleGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);

  if (horAnchor == null) {
    horAnchor = detectTopGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);
  }

  return new Point(verAnchor, horAnchor);
}

Point detectResizeNEAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int verAnchor;
  int horAnchor;
  //TODO: also find equal gaps

  verAnchor = detectHorMiddleGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);

  if (verAnchor == null) {
    verAnchor = detectRightGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);
  }

  horAnchor = detectVerMiddleGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);

  if (horAnchor == null) {
    horAnchor = detectTopGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);
  }

  return new Point(verAnchor, horAnchor);
}

Point detectResizeSEAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int verAnchor;
  int horAnchor;
  //TODO: also find equal gaps

  verAnchor = detectHorMiddleGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);

  if (verAnchor == null) {
    verAnchor = detectRightGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);
  }

  horAnchor = detectVerMiddleGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);

  if (horAnchor == null) {
    horAnchor = detectBottomGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);
  }

  return new Point(verAnchor, horAnchor);
}

Point detectResizeSWAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int verAnchor;
  int horAnchor;
  //TODO: also find equal gaps

  verAnchor = detectHorMiddleGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);

  if (verAnchor == null) {
    verAnchor = detectLeftGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);
  }

  horAnchor = detectVerMiddleGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);

  if (horAnchor == null) {
    horAnchor = detectBottomGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);
  }

  return new Point(verAnchor, horAnchor);
}

Point detectResizeNAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int horAnchor;
  //TODO: also find equal gaps

  horAnchor = detectVerMiddleGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);

  if (horAnchor == null) {
    horAnchor = detectTopGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);
  }

  return new Point(null, horAnchor);
}

Point detectResizeSAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int horAnchor;
  //TODO: also find equal gaps

  horAnchor = detectVerMiddleGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);

  if (horAnchor == null) {
    horAnchor = detectBottomGL(a_sel_rect, a_scaled_size.y.toInt(), a_elements, a_selEls);
  }

  return new Point(null, horAnchor);
}

Point detectResizeEAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int verAnchor;
  //TODO: also find equal gaps

  verAnchor = detectHorMiddleGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);

  if (verAnchor == null) {
    verAnchor = detectRightGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);
  }

  return new Point(verAnchor, null);
}

Point detectResizeWAutoGuidelines(Rectangle a_sel_rect, Point a_scaled_size, List<StageElement> a_elements, Set<StageElement> a_selEls) {
  int verAnchor;
  //TODO: also find equal gaps

  verAnchor = detectHorMiddleGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);

  if (verAnchor == null) {
    verAnchor = detectLeftGL(a_sel_rect, a_scaled_size.x.toInt(), a_elements, a_selEls);
  }

  return new Point(verAnchor, null);
}