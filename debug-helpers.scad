
module vector(v, length, r=.5) {
  x = v.x;
  y = v.y;
  z = v.z;
  length_ = norm(v);
  length = is_undef(length) ? length_ : length;

  if (length_ > 0) {
    theta = atan2(x, -y); // equator angle around z-up axis
    phi = acos( min( max(z / length_, -1), 1) ); // polar angle

    rotate([0, 0, theta])
    rotate([phi, 0, 0]) {
      cylinder(r1=r, r2=r * .8, h=length * .95);
      translate([0, 0, length * .95])
        cylinder(r1=r * .8, r2=0, h=length * .05);
    }
  }
}

/**
 * A nice XYZ axis indicator to clarify a transformation matrix's orientation.
 */
module axes(length=30) {
  color("coral") vector([1, 0, 0] * length);
  color("mediumseagreen") vector([0, 1, 0] * length);
  color("blue") vector([0, 0, 1] * length);
}

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

/**
 * Debug complex hull groups by assigning a different colour to each child.
 *
 * Each child module should be preceeded by `debug(i)` where `i` is the child's
 * index, and somewhere in the context of using `debug()` the special variable
 * `$debug` must be set and evaluate to a non-false value.
 *
 * @param Integer i - child index, used to assign a colour in the debug colour sequence.
 * @param Boolean [$debug=false] - toggle (at a higher context) whether to actually apply debug colouring.
 */
module debug(i) {
  if (!is_undef($debug) && $debug != false) {
    color(_debug_colors[i % len(_debug_colors)])
    children();
  } else {
    children();
  }
}
