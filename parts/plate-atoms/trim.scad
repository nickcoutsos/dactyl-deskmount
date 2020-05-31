use <../../scad-utils/linalg.scad>
use <../../scad-utils/transformations.scad>

use <../../geometry.scad>
use <../../positioning.scad>
use <../../positioning-transformations.scad>
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

module back_plate() {
  triangle_hulls() {
    led_edge_s(3) plate_edge(horizontal=true);
    position_back_plate_bottom_right() plate_corner();
    thumb_corner_ne(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    position_back_plate_top_right() plate_corner();
    thumb_corner_nw(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    position_back_plate_top_mid() plate_corner();
    thumb_corner_ne(2, 2) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    position_back_plate_top_left() plate_corner();

    thumb_corner_nw(2, 2) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    position_back_plate_bottom_left() plate_corner();
  }

  hull() {
    position_back_plate() translate([-15, -5, 0]) plate_corner();
    position_back_plate() translate([+15, -5, 0]) plate_corner();
    position_back_plate() translate([+15, +15, 0]) plate_corner();
    position_back_plate() translate([-plate_dimensions.x, +15, 0]) plate_corner();
  }
}

module perimeter() {
  // main trim
  // perimeter of thumb and finger cluster without backplate and led column)
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
      led_corner_se(3) plate_corner();
      finger_corner_nw(0, 3) plate_corner();
    }
  }

  // thumb top left corner
  serial_hulls() {
    thumb_corner_nw(2, 2) edge_profile(0);
    thumb_corner_nw(2, 2) edge_profile(30);
    thumb_corner_nw(2, 2) edge_profile(60);
    thumb_corner_nw(2, 2) edge_profile(90);
  }

  // back plate and led column trim
  serial_hulls() {
    thumb_corner_nw(2, 2)
    translate([0, 0, -plate_thickness*1.5])
    rotate([-90, 0, 0])
    translate([0, 0, plate_thickness])
      edge_profile(0);

    position_back_plate_bottom_left()
    translate([0, 0, -plate_thickness])
    rotate([180, 0, 0]) {
      edge_profile(30);
      edge_profile(50);
      edge_profile(70);
    }

    position_back_plate_bottom_right()
    translate([0, 0, -plate_thickness])
    rotate([180, 0, 0])
      edge_profile(60);

    // thumb to led column
    led_corner_sw(3) rotate([0, 0, 0]) edge_profile(0);
    led_corner_sw(3) edge_profile(0);
    led_corner_nw(3) edge_profile(0);
    led_corner_sw(2) edge_profile(0);
    led_corner_nw(2) edge_profile(0);
    led_corner_sw(1) edge_profile(0);
    led_corner_nw(1) edge_profile(0);
    led_corner_sw(0) edge_profile(0);
    led_corner_nw(0) edge_profile(0);
    led_corner_nw(0) edge_profile(30);
    led_corner_nw(0) edge_profile(60);
    led_corner_nw(0) edge_profile(90);
    led_corner_ne(0) rotate([0, 30, 0]) edge_profile(90);
    finger_corner_nw(0, 1) edge_profile(90);
  }
}

module plate_trim() {
  back_plate();

  perimeter();

  post_place(0) screw_post();
  post_place(1) screw_post();
  post_place(2) screw_post();
  post_place(3) screw_post();
  post_place(4) screw_post();

  // breakout board holders
  position_back_plate()
  for (offset=[-11.5, 1, 15])
    translate([offset, 1, .8])
    rotate([90, 0, 0])
      cylinder(d=3, h=7);
}
