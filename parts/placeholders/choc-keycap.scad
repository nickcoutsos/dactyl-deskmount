include <../../switch-and-keycap-specs.scad>

module kailh_choc_keycap() {
  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  rot = !is_undef($rot) ? $rot : 0;
  pressed = !is_undef($key_pressed) && $key_pressed == true;

  width = choc_keycap_width * (rot == 90 ? h : u);
  depth = choc_keycap_depth * (rot == 90 ? u : h);
  height = choc_keycap_height;

  top_width = width - 2.6;
  top_depth = depth - 3.4;
  mount_height = choc_keycap_top_height
    - (pressed ? choc_switch_travel : 0)
    - height;

  translate([0, 0, mount_height])
  rotate([0, 0, rot])
  difference() {
    hull() {
      linear_extrude(height=.1) square([width, depth], center=true);
      translate([0, 0, 1.7]) linear_extrude(height=.1) square([width, depth], center=true);
      translate([0, 0.8, 3.5]) linear_extrude(height=.1) square([top_width, top_depth], center=true);
    }

    if (!is_undef($detail) && $detail) {
      translate([0, 0, 3 +90])
      rotate([90, 0, 0])
      scale([u, 1, h])
      sphere(r=90, $fa=1);
    }
  }
}
