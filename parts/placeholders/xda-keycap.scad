use <../../util.scad>
include <../../switch-and-keycap-specs.scad>

module xda_keycap(steps=4) {
  u = is_undef($u) ? 1 : $u;
  h = is_undef($h) ? 1 : $h;
  rot = !is_undef($rot) ? $rot : 0;
  detail = !is_undef($detail) && $detail;
  pressed = !is_undef($key_pressed) && $key_pressed;

  bottom_radius = xda_bottom_corner_radius;
  top_radius = xda_top_corner_radius;
  dish_radius = 90;

  width = xda_keycap_width * (rot == 90 ? h : u);
  depth = xda_keycap_depth * (rot == 90 ? u : h);
  height = xda_keycap_height;
  mount_height = xda_keycap_top_height
    - (pressed ? mx_switch_travel : 0)
    - height;

  inset = [
    (xda_keycap_width - xda_top_width) / 2,
    (xda_keycap_depth - xda_top_depth) / 2,
    0
  ];

  module cap() {
    hull()
    mirror_axes([[1, 0, 0]])
    mirror_axes([[0, 1, 0]])
    for (i=[0:steps]) {
      t = i / steps;
      corner = -[width, depth, 0] / 2 + inset * t*t;
      corner_radius = bottom_radius + t*t * (top_radius - bottom_radius);

      translate(corner)
      translate([0, 0, xda_keycap_height] * t)
      translate([1, 1, 0] * corner_radius )
        cylinder(r=corner_radius, h=0.01, $fn=8);
    }
  }

  module cavity() {
    translate([0, 0, -0.01])
    scale([
      (width - xda_keycap_thickness * 2) / width,
      (depth - xda_keycap_thickness * 2) / depth,
      (height - xda_keycap_thickness) / height
    ]) cap();
  }

  module dish() {
    translate([0, 0, xda_keycap_height - 0.55 +dish_radius])
    rotate([90, 0, 0])
    scale([u, 1, h])
      sphere(r=dish_radius, $fa=1);
  }

  module stem() {
    cylinder(d=5.25, h=xda_keycap_height - 1);
  }

  translate([0, 0, mount_height])
  rotate([0, 0, rot])
  color("lightgray") {
    if (detail) stem();
    difference() {
      cap();
      if (detail) cavity();
      if (detail) dish();
    }
  }
}

xda_keycap();
