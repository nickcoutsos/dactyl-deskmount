use <../../geometry.scad>
use <../../util.scad>
include <../../switch-and-keycap-specs.scad>

module xda_keycap(steps=4) {
  u = is_undef($u) ? 1 : $u;
  h = is_undef($h) ? 1 : $h;
  rot = !is_undef($rot) ? $rot : 0;
  x = rot == 90 ? h : u;
  y = rot == 90 ? u : h;
  detail = !is_undef($detail) && $detail;
  pressed = !is_undef($key_pressed) && $key_pressed;

  bottom_radius = xda_bottom_corner_radius;
  top_radius = xda_top_corner_radius;
  dish_radius = 90;

  width = xda_keycap_width * x;
  depth = xda_keycap_depth * y;
  height = xda_keycap_height;
  mount_height = xda_keycap_top_height
    - (pressed ? mx_switch_travel : 0)
    - height;

  inset = [
    (xda_keycap_width - xda_top_width) / 2,
    (xda_keycap_depth - xda_top_depth) / 2,
    0
  ];

  module draw_layer_profile(r, s, steps) {
    points = [for (p=make_squircle(r, s, steps)) [
      (p.x != 0 && x > 1) ? sign(p.x) * (width/2 - xda_keycap_width/2) + p.x: p.x,
      (p.y != 0 && y > 1) ? sign(p.y) * (depth/2 - xda_keycap_depth/2) + p.y: p.y
    ]];

    polygon(points);
  }

  module cap() {
    s = [3.75, 10];
    r = [xda_top_width/2, xda_keycap_width/2];

    hull()
    {
      for (i=[0:steps-1]) {
        t = i / steps;
        echo(t);

        translate([0, 0, xda_keycap_height] * t)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=r[1] + (r[0] - r[1]) * t*t,
          s=s[1] + (s[0] - s[1]) * t,
          steps=40
        );
      }

      translate([0, 0, xda_keycap_height] * 0.99)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=xda_top_width/2 * 0.99,
          s=s[1] + (s[0] - s[1]) * 0.99,
          steps=40
        );


      translate([0, 0, xda_keycap_height] * 1.025)
        linear_extrude(height=0.1)
        draw_layer_profile(
          r=xda_top_width/2 * .95,
          s=s[1] + (s[0] - s[1]) * 1.025,
          steps=40
        );

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
    translate([0, 0, xda_keycap_height -.05 +dish_radius])
    rotate([90, 0, 0])
    scale([x, 1, y])
      sphere(r=dish_radius, $fa=1);
  }

  module stem() {
    cylinder(d=5.25, h=xda_keycap_height - 1);
  }

  translate([0, 0, mount_height])
  color("whitesmoke") {
    if (detail) stem();
    difference() {
      cap();
      if (detail) cavity();
      if (detail) dish();
    }
  }
}

xda_keycap($detail=true, steps=5);
