use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>

use <../debug-helpers.scad>
use <../positioning.scad>
use <../positioning-transformations.scad>
use <../util.scad>
include <../definitions.scad>

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
      led_corner_ne(0) translate([-0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_se(0) translate([-0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_ne(1) translate([-0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_se(1) translate([-0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_ne(2) translate([-0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_se(2) translate([-0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_ne(3) translate([-0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_se(3) translate([-0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);

      led_corner_sw(3) translate([+0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_nw(3) translate([+0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_sw(2) translate([+0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_nw(2) translate([+0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_sw(1) translate([+0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_nw(1) translate([+0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_sw(0) translate([+0.75, +0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
      led_corner_nw(0) translate([+0.75, -0.75, -plate_thickness]) cylinder(d=1, h=plate_thickness);
    }
  }

  module lip() {
    serial_hulls(close=true) {
      led_corner_ne(0) hull() { translate([-0.75, 0, 0]) half_sphere(d=1); translate([-0.75, -0.75, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_se(0) hull() { translate([-0.75, 0, 0]) half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_ne(1) hull() { translate([-0.75, 0, 0]) half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_se(1) hull() { translate([-0.75, 0, 0]) half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_ne(2) hull() { translate([-0.75, 0, 0]) half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_se(2) hull() { translate([-0.75, 0, 0]) half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_ne(3) hull() { translate([-0.75, 0, 0]) half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_se(3) translate([0, 0.75, 0]) hull() { translate([-0.75, 0, 0]) half_sphere(d=1); translate([-0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }

      led_corner_sw(3) translate([0, 0.75, 0]) hull() { translate([0.75, 0, 0]) half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_nw(3) hull() { translate([0.75, 0, 0]) half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_sw(2) hull() { translate([0.75, 0, 0]) half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_nw(2) hull() { translate([0.75, 0, 0]) half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_sw(1) hull() { translate([0.75, 0, 0]) half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_nw(1) hull() { translate([0.75, 0, 0]) half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_sw(0) hull() { translate([0.75, 0, 0]) half_sphere(d=1); translate([+0.75, 0, 0.25]) cube([1, 1, 0.5], center=true); }
      led_corner_nw(0) hull() { translate([0.75, 0, 0]) half_sphere(d=1); translate([+0.75, -0.75, 0.25]) cube([1, 1, 0.5], center=true); }
    }
  }

  module roof() {
    poly_hulls([
      [0, 1, 2],
      [1, 2, 3, 5],
      [2, 4, 5, 6],
      [5, 6, 7, 9],
      [6, 8, 9, 10],
      [9, 10, 11, 13],
      [10, 12, 13, 14],
      [13, 14, 15, 17],
      [14, 17, 16]
    ]) {
      led_corner_nw(0) translate([0+1, 0-0.75, 0-0.5]) sphere(d=.5);
      led_corner_ne(0) translate([0-1, 0-0.75, 0-0.5]) sphere(d=.5);
      led_edge_w(0)    translate([0+1, 0, 0-0.5]) sphere(d=.5);
      led_edge_e(0)    translate([-1.5-1, 0, 1.25-0.5]) sphere(d=.5);
      led_corner_sw(0) translate([+1.5+1, 0, 1.25-0.5]) sphere(d=.5);
      led_corner_se(0) translate([0-1, 0, 0-0.5]) sphere(d=.5);

      led_edge_w(1)    translate([0+1, 0, 0-0.5]) sphere(d=.5);
      led_edge_e(1)    translate([-1.5-1, 0, 1.25-0.5]) sphere(d=.5);
      led_corner_sw(1) translate([+1.5+1, 0, 1.25-0.5]) sphere(d=.5);
      led_corner_se(1) translate([0-1, 0, 0-0.5]) sphere(d=.5);

      led_edge_w(2)    translate([0+1, 0, 0-0.5]) sphere(d=.5);
      led_edge_e(2)    translate([-1.5-1, 0, 1.25-0.5]) sphere(d=.5);
      led_corner_sw(2) translate([+1.5+1, 0, 1.25-0.5]) sphere(d=.5);
      led_corner_se(2) translate([0-1, 0, 0-0.5]) sphere(d=.5);

      led_edge_w(3)    translate([0+1, 0, 0-0.5]) sphere(d=.5);
      led_edge_e(3)    translate([-1.5-1, 0, 1.25-0.5]) sphere(d=.5);
      led_corner_sw(3) translate([0+1, 0.75, 0-0.5]) sphere(d=.5);
      led_corner_se(3) translate([0-1, 0.75, 0-0.5]) sphere(d=.5);
    }
  }

  box();
  lip();
  roof();
}

led_column_bottom = led_edge_transformation_s(3);

rotate([90, 0, 0])
multmatrix(invert_rt(led_column_bottom)) {
  translate([0, -0.25, 0]) led_diffuser();

  multmatrix(led_column_bottom) translate([2, 0, -8]) rotate([-90, 0, 0]) cylinder(d=10, h=2);
  serial_hulls() {
    led_corner_ne(0) translate([-0.75, -1, -plate_thickness]) rotate([0, 35, 0]) rotate([75, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -1.5, 0]) cylinder(d=1.5); }
    led_corner_se(0) translate([-0.75, +1, -plate_thickness]) rotate([0, 35, 0]) rotate([80, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -2, 0]) cylinder(d=1.5); }
    led_corner_se(1) translate([-0.75, +1, -plate_thickness]) rotate([0, 35, 0]) rotate([90, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -4, 0]) cylinder(d=1.75); }
    led_corner_se(2) translate([-0.75, +1, -plate_thickness]) rotate([0, 35, 0]) rotate([90, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -6, 0]) cylinder(d=2); }
    led_corner_se(3) translate([-0.75, +1.25, -plate_thickness]) rotate([0, 35, 0]) rotate([90, 0, 0]) hull() { translate([0, -0.1, 0]) cylinder(d=0.45); translate([0, -6, 0]) cylinder(d=4); }
  }
}
