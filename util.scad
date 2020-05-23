use <debug-helpers.scad>

/**
 * Make a "triangle" strip by hulling triplets of child nodes.
 */
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

/**
 * Hull a series of children together. Instead of a single hull composed of
 * every child it's a sequence of hulls of adjacent (in terms of module order)
 * children.
 *
 * @param bool [close=false] make a closed "loop" by hulling the first and last child
 */
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

/**
 * For complex geometries based on groups of hulls with some overlap.
 *
 * Each array in `path` represents a group of child nodes to be hulled together.
 *
 * @param Array<Array<Integer>> paths - an array of arrays of child indices
 */
module poly_hulls(paths) {
  for (i=[0:len(paths)-1]) {
    debug(i) hull() for (j=paths[i]) children(j);
  }
}

/**
 * Like mirror() except it results in both the original and mirrored version. It
 * also lets you specify multiple mirror axes so you can use one transformation
 * to make an instance of the child in each quadrant/octant.
 */
module mirror_axes(axes) {
  children();
  for (axis=axes)
    mirror(axis)
      children();
}
