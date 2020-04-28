use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

use <positioning.scad>
use <util.scad>
include <definitions.scad>

led_transform = rotation([0, -60, 0]);
led_offset = [-6, 0, 0];
led_size = 0.52;
leds = [
  [-0.75, 0.82],
  [-0.75, 1.2],
  [-0.75, 1.58],
  [-0.75, 1.96]
];

module poly_hulls(paths) {
  for (i=[0:len(paths)-1]) {
    debug(i) hull() for (j=paths[i]) children(j);
  }
}

module led_diffuser() {
  $fn=13;
  module half_sphere(d=1) {
    difference() {
      sphere(d=d);
      translate([0, 0, -d/2 - 0.5]) cube([d+1, d+1, d+1], center=true);
    }
  }

  module box() {
    serial_hulls(close=true) {
      finger_corner_ne(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_se(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_ne(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_se(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_ne(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_se(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_ne(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_se(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);

      finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([+0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_nw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([+0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_sw(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([+0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_nw(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([+0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_sw(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([+0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_nw(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([+0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_sw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([+0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([+0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
    }
  }

  module lip() {
    serial_hulls(close=true) {
      finger_corner_ne(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([-0.75, -0.75, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_se(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_ne(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_se(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_ne(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_se(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_ne(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_se(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0.75, 0]) hull() { half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }

      finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0.75, 0]) hull() { half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_nw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_sw(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_nw(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_sw(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_nw(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_sw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) hull() { half_sphere(d=1); translate([+0.75, -0.75, 0.25]) cube([1, 1, 0.5], center=true); }
    }
  }

  module n(led) { finger_edge_n(led.x, led.y, led_transform, $u=led_size, $h=led_size) translate(led_offset) children(); }
  module ne(led) { finger_corner_ne(led.x, led.y, led_transform, $u=led_size, $h=led_size) translate(led_offset) children();}
  module e(led) { finger_edge_e(led.x, led.y, led_transform, $u=led_size, $h=led_size) translate(led_offset) children(); }
  module se(led) { finger_corner_se(led.x, led.y, led_transform, $u=led_size, $h=led_size) translate(led_offset) children(); }
  module s(led) { finger_edge_s(led.x, led.y, led_transform, $u=led_size, $h=led_size) translate(led_offset) children(); }
  module sw(led) { finger_corner_sw(led.x, led.y, led_transform, $u=led_size, $h=led_size) translate(led_offset) children(); }
  module w(led) { finger_edge_w(led.x, led.y, led_transform, $u=led_size, $h=led_size) translate(led_offset) children(); }
  module nw(led) { finger_corner_nw(led.x, led.y, led_transform, $u=led_size, $h=led_size) translate(led_offset) children(); }

  module roof() {
    poly_hulls([
      [0, 1, 2],
      [1, 2, 3],
      [2, 3, 5],
      [2, 4, 5],
      [4, 5, 6],
      [5, 6, 7],
      [6, 7, 9],
      [6, 8, 9],
      [8, 9, 10],
      [9, 10, 11],
      [10, 11, 13],
      [10, 12, 13],
      [12, 13, 14],
      [13, 14, 15],
      [14, 15, 17],
      [14, 17, 16],

      [1, 3, 5],
      [5, 7, 9],
      [9, 11, 13],
      [13, 15, 17],

      [2, 4, 6],
      [6, 8, 10],
      [10, 12, 14]
    ]) {
      nw(leds[0]) translate([0+1, 0-0.75, 0-0.5]) sphere(d=.5);
      ne(leds[0]) translate([0-1, 0-0.75, 0-0.5]) sphere(d=.5);
      w(leds[0]) translate([0+1, 0, 0-0.5]) sphere(d=.5);
      e(leds[0]) translate([-1.5-1, 0, 1.25-0.5]) sphere(d=.5);
      sw(leds[0]) translate([+1.5+1, 0, 1.25-0.5]) sphere(d=.5);
      se(leds[0]) translate([0-1, 0, 0-0.5]) sphere(d=.5);

      w(leds[1]) translate([0+1, 0, 0-0.5]) sphere(d=.5);
      e(leds[1]) translate([-1.5-1, 0, 1.25-0.5]) sphere(d=.5);
      sw(leds[1]) translate([+1.5+1, 0, 1.25-0.5]) sphere(d=.5);
      se(leds[1]) translate([0-1, 0, 0-0.5]) sphere(d=.5);

      w(leds[2]) translate([0+1, 0, 0-0.5]) sphere(d=.5);
      e(leds[2]) translate([-1.5-1, 0, 1.25-0.5]) sphere(d=.5);
      sw(leds[2]) translate([+1.5+1, 0, 1.25-0.5]) sphere(d=.5);
      se(leds[2]) translate([0-1, 0, 0-0.5]) sphere(d=.5);

      w(leds[3]) translate([0+1, 0, 0-0.5]) sphere(d=.5);
      e(leds[3]) translate([-1.5-1, 0, 1.25-0.5]) sphere(d=.5);
      sw(leds[3]) translate([0+1, 0.75, 0-0.5]) sphere(d=.5);
      se(leds[3]) translate([0-1, 0.75, 0-0.5]) sphere(d=.5);
    }
  }

  box();
  lip();
  roof();
}

led_column_bottom = (
  finger_place_transformation(leds[3].x, leds[3].y, $u=led_size, $h=led_size)
  * led_transform
  * translation([0, -plate_height/2*led_size, 0])
  * translation(led_offset)
);

rotate([90, 0, 0])
multmatrix(invert_rt(led_column_bottom)) {
  translate([0, -0.25, 0]) led_diffuser();

  multmatrix(led_column_bottom) translate([2, 0, -8]) rotate([-90, 0, 0]) cylinder(d=10, h=2);
  serial_hulls() {
    finger_corner_ne(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, -1, -plate_thickness]) rotate([0, 35, 0]) rotate([75, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -1.5, 0]) cylinder(d=1.5); }
    finger_corner_se(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, +1, -plate_thickness]) rotate([0, 35, 0]) rotate([80, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -2, 0]) cylinder(d=1.5); }
    finger_corner_se(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, +1, -plate_thickness]) rotate([0, 35, 0]) rotate([90, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -4, 0]) cylinder(d=1.75); }
    finger_corner_se(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, +1, -plate_thickness]) rotate([0, 35, 0]) rotate([90, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -6, 0]) cylinder(d=2); }
    finger_corner_se(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([-0.75, +1.25, -plate_thickness]) rotate([0, 35, 0]) rotate([90, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -6, 0]) cylinder(d=4); }
  }
}
