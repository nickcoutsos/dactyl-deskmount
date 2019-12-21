use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

use <placeholders.scad>
use <positioning.scad>
use <util.scad>
use <main.scad>
include <definitions.scad>

keyboard_offset = [35, 10, -10];
posts = [
  rotation([0, -20, 0]) * translation(keyboard_offset) * thumb_place_transformation(2, 1) * translation([10, -10, 0]) * rotation([-20, 0, 0]),
  rotation([0, -20, 0]) * translation(keyboard_offset) * finger_place_transformation(2, 3.5) * translation([-8, 0, 0]) * rotation([0, 0, 0]),
  rotation([0, -20, 0]) * translation(keyboard_offset) * finger_place_transformation(1, 0.5) * rotation([-20, 0, 0])
];

module screw_post() {
   translate([0, 0, -10 -plate_thickness])
   cylinder(d=6, h=10);
}

ball_mount([0, 20, 0]) {


  color("gold") tee_nut();

  rotate([0, -20, 0])
  translate(keyboard_offset) {
    color("lightsteelblue") assembled_plate();
    color("lightsteelblue") plate_trim();
    // accessories();
  }

  color("forestgreen") cylinder(d=28, h=5.5);

  multmatrix(posts[0]) screw_post();
  multmatrix(posts[1]) screw_post();
  multmatrix(posts[2]) screw_post();

  hull() { rotate([0, 0, 220]) translate([10, 0, 0]) cylinder(d=10, h=5.5); multmatrix(posts[0]) translate([0, 0, -15]) cylinder(d=6, h=5); }
  hull() { rotate([0, 0, -30]) translate([10, 0, 0]) cylinder(d=10, h=5.5); multmatrix(posts[1]) translate([0, 0, -15]) cylinder(d=6, h=5); }
  hull() { rotate([0, 0, 55]) translate([10, 0, 0]) cylinder(d=10, h=5.5); multmatrix(posts[2]) translate([0, 0, -15]) cylinder(d=6, h=5); }
  // hull() { cylinder(d=20, h=5.5); translate(keyboard_offset) finger_place(2, 3.5) translate([-8, 0, 0]) translate([0, 0, -8 - plate_thickness]) cylinder(d=6, h=5); }
  // hull() { cylinder(d=20, h=5.5); translate(keyboard_offset) finger_place(1, 0.5) translate([0, 0, 0]) rotate([-30, 0, 0]) translate([0, 0, -8 - plate_thickness]) cylinder(d=6, h=5); }
}

module tee_nut() {
  translate([0, 0, 5.97])
  rotate([180, 0, 0]) {
    cylinder(d=19, h=1.19);
    cylinder(d=7.7, h=5.97);
    rotate([0, 0, 90*1]) translate([19/2-1.2, 0, 3.17/2]) cube([2, .6, 3.17], center=true);
    rotate([0, 0, 90*2]) translate([19/2-1.2, 0, 3.17/2]) cube([2, .6, 3.17], center=true);
    rotate([0, 0, 90*3]) translate([19/2-1.2, 0, 3.17/2]) cube([2, .6, 3.17], center=true);
    rotate([0, 0, 90*4]) translate([19/2-1.2, 0, 3.17/2]) cube([2, .6, 3.17], center=true);
  }
}
