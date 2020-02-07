
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

module mirror_axes(axes) {
  children();
  for (axis=axes)
    mirror(axis)
      children();
}


module truncated_sphere(r=undef, d=undef, rr=0.8) {
  radius = is_undef(r) ? (is_undef(d) ? 2 : d / 2) : r;
  difference() {
    rotate([0, 90, 0]) sphere(radius);
    translate([-radius, 0, 0]) cube([(1 - rr) * radius, radius, radius] * 2, center=true);
    translate([+radius, 0, 0]) cube([(1 - rr) * radius, radius, radius] * 2, center=true);
  }
}

module lobed_cylinder(radius, h=2) {
  lobes = 6;
  translate([0, 0, h/2])
  difference() {
    $fn=24;

    hull()
    for (i=[1:lobes]) {
      rotate([0, 0, i*360/lobes])
      translate([radius, 0, 0]) {
        cylinder(r=radius/5, h=h-1, center=true);
        cylinder(r=0.8*radius/5, h=h, center=true);
      }
    }

    for (i=[1:lobes]) {
      rotate([0, 0, (i-0.5)*360/lobes])
      translate([9/5*radius, 0, 0]) {
        cylinder(r=0.825*radius, h=h+0.1, center=true, $fn=76);
        translate([0, 0, h/2]) cylinder(r1=0.825*radius, r2=1.2*0.825*radius, h=1, center=true, $fn=76);
        translate([0, 0, -h/2]) cylinder(r2=0.825*radius, r1=1.2*0.825*radius, h=1, center=true, $fn=76);
      }
    }
  }
}
