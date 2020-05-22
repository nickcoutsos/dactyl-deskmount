use <../../scad-utils/linalg.scad>
use <../../scad-utils/transformations.scad>

use <../../geometry.scad>
use <../../positioning.scad>
use <../../util.scad>
use <../placeholders/3535-led.scad>
use <corner.scad>
use <edge.scad>
use <trim-profile.scad>
include <../../definitions.scad>

module screw_post() {
  outer = 11;
  depth = 4;
  hull() {
    translate([0, depth, 1]) cube([outer + 2, 0.1, 4], center=true);
    translate([0, 0, -1]) rotate([0, 0, 180]) arc(180, r1=outer/2, r2=0, h=4);
  }
  translate([0, 0, -2]) cylinder(d=5.5, h=3);
}

module screw_cutout() {
  cylinder(d=3, h=plate_thickness*4, center=true);
  cylinder(d=4.5, h=5);
  translate([0, 0, 2]) cylinder(d1=3, d2=7, h=5, center=true);
}

module plate_trim() {
  detail = is_undef($detail) ? false : $detail;

  hull() {
    finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_edge(horizontal=true);
    thumb_corner_nw(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    thumb_corner_ne(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
  }

  triangle_hulls() {
    thumb_corner_nw(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    thumb_corner_ne(2, 2) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    thumb_corner_nw(2, 2)
    translate([4, 3, -22])
    translate([0, 0, -plate_thickness*1.5])
    translate([0, 0, plate_thickness])
    rotate([-90, 0, 0])
      plate_corner();
    thumb_corner_nw(2, 2) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
  }

  serial_hulls(close=false) {
    // top left corner
    finger_corner_nw(0, 1) edge_profile(90);
    finger_corner_ne(0, 1) edge_profile(90);

    // top edge
    finger_corner_nw(1, 1) edge_profile(90);
    finger_edge_n(1, 1) edge_profile(90);
    finger_corner_ne(1, 1) edge_profile(45, stretch=true);
    finger_corner_nw(2, 1) edge_profile(60);
    finger_corner_ne(2, 1) edge_profile(120);
    finger_corner_nw(3, 1) edge_profile(110);
    finger_corner_ne(3, 1) edge_profile(120);
    finger_corner_nw(4, 1) edge_profile(135, stretch=true);
    finger_corner_ne(4, 1) edge_profile(90);
    finger_corner_nw(5, 1) edge_profile(90);

    // top right corner
    finger_corner_ne(5, 1) edge_profile(110);
    finger_corner_ne(5, 1) edge_profile(140);

    // right edge
    finger_corner_se(5, 1) edge_profile(180);
    finger_corner_ne(5, 2) edge_profile(180);
    finger_corner_se(5, 2) edge_profile(180);
    finger_corner_ne(5, 3) edge_profile(180);
    finger_corner_se(5, 3) edge_profile(180);

    // bottom right corner
    finger_corner_se(5, 3) edge_profile(210);
    finger_corner_se(5, 3) edge_profile(240);

    // bottom edge
    finger_corner_sw(5, 3) edge_profile(270);
    finger_corner_se(4, 3) edge_profile(270);
    finger_corner_sw(4, 3) edge_profile(270-45, stretch=true);
    finger_corner_se(3, 4) edge_profile(220);
    finger_corner_se(3, 4) edge_profile(270);
    finger_corner_sw(3, 4) edge_profile(270);
    finger_corner_sw(3, 4) edge_profile(300);
    finger_corner_se(2, 4) edge_profile(300);
    finger_corner_sw(2, 4) edge_profile(240);
    finger_corner_se(1, 4) edge_profile(240);
    finger_corner_se(1, 4) edge_profile(270);
    finger_corner_sw(1, 4) edge_profile(235, stretch=true);

    // thumb bottom edge
    thumb_edge_e(0, 0) edge_profile(235, stretch=true);
    thumb_corner_se(0, 0) edge_profile(200);
    thumb_corner_se(0, 0) edge_profile(240);
    thumb_corner_sw(0, 0) edge_profile(270);
    thumb_corner_se(1, 0) edge_profile(270);
    thumb_corner_sw(1, 0) edge_profile(270);
    thumb_corner_se(2, 0) edge_profile(270);
    thumb_corner_sw(2, 0) edge_profile(270);

    // thumb bottom left corner
    thumb_corner_sw(2, 0) edge_profile(300);
    thumb_corner_sw(2, 0) edge_profile(330);
    thumb_corner_nw(2, 0) edge_profile(0);
    thumb_corner_sw(2, 1) edge_profile(0);
    thumb_corner_nw(2, 1) edge_profile(0);
    thumb_corner_sw(2, 2) edge_profile(0);
    thumb_corner_nw(2, 2) edge_profile(0);

    thumb_corner_nw(2, 2) edge_profile(90);
    thumb_corner_ne(2, 2) edge_profile(90);
    thumb_corner_nw(1, 1) edge_profile(90);
    thumb_corner_ne(1, 1) edge_profile(90);

    thumb_corner_ne(1, 1)
    translate([0, 0, -plate_thickness * 1.5])
    rotate([0, 30, 0])
    translate([0, 0, plate_thickness * 1.5])
      edge_profile(90);

    thumb_corner_ne(1, 1)
    translate([0, 0, -plate_thickness * 1.5])
    rotate([0, 60, 0])
    translate([0, 0, plate_thickness * 1.5])
      edge_profile(90);

    hull() {
      finger_corner_se(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
      finger_corner_nw(0, 3) plate_corner();
    }
  }

  serial_hulls() {
    // thumb top left corner
    thumb_corner_nw(2, 2) edge_profile(0);
    thumb_corner_nw(2, 2) edge_profile(30);
    thumb_corner_nw(2, 2) edge_profile(60);
    thumb_corner_nw(2, 2) edge_profile(90);
  }

  serial_hulls() {
    thumb_corner_nw(2, 2)
    translate([0, 0, -plate_thickness*1.5])
    rotate([-90, 0, 0])
    translate([0, 0, plate_thickness])
      edge_profile(0);

    thumb_corner_nw(2, 2)
    translate([4, 3, -22])
    translate([0, 0, -plate_thickness*1.5])
    translate([0, 0, plate_thickness])
    rotate([-90, 0, 0]) {
      edge_profile(30);
      edge_profile(50);
      edge_profile(70);
    }

    // thumb to led column
    finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) rotate([-90, 0, 0]) edge_profile(30);
    finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) rotate([0, 0, 0]) edge_profile(0);
    finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_sw(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_sw(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_sw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(30);
    finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(60);
    finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(90);
    finger_corner_ne(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) rotate([0, 30, 0]) edge_profile(90);
    finger_corner_nw(0, 1) edge_profile(90);
  }

  post_place(0) screw_post();
  post_place(1) screw_post();
  post_place(2) screw_post();
  post_place(3) screw_post();
  post_place(4) screw_post();

  multmatrix(thumb_place_transformation(1.5, 1.5))
  rotate([0, 5, 0])
  rotate([81, 0, 0])
  for (offset=[-11.5, 1, 15])
    translate([offset, -19, .8])
    rotate([90, 0, 0])
      cylinder(d=3, h=7);
}
