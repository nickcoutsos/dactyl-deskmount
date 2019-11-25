
_debug_colors = [
  "tomato",
  "peachpuff",
  "rosybrown",
  "yellowgreen",
  "mediumseagreen",
  "skyblue",
  "steelblue",
  "mediumorchid",
  "slategray"
];

module debug(i) {
  if (!is_undef($debug) && $debug != false) {
    color(_debug_colors[i % len(_debug_colors)])
    children();
  } else {
    children();
  }
}

module triangle_hulls() {
  for (i=[0:$children - 3]) {
    debug(i)
    hull() {
      children(i);
      children(i+1);
      children(i+2);
    }
  }
}

module serial_hulls(close=false) {
  for (i=[0:$children-2]) {
    debug(i)
    hull() {
      children(i);
      children(i+1);
    }
  }

  if (close) {
    hull() {
      children(0);
      children($children - 1);
    }
  }
}
