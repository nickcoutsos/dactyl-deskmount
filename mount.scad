use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

use <placeholders.scad>
use <positioning.scad>
use <util.scad>
use <main.scad>
include <definitions.scad>

keyboard_offset = rotation([0, -20, 0]) * translation([35, 10, -10]);
posts = [
  keyboard_offset * thumb_place_transformation(2, 0.5) * translation([15, -5, 0]),
  keyboard_offset * finger_place_transformation(2, 3.5) * translation([8, 0, 0]),
  keyboard_offset * finger_place_transformation(0.5, 1)
];

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

module screw_post() {
   translate([0, 0, -5 -plate_thickness])
   cylinder(d=6, h=10);
}

module arc(a=90, r1=1, r2=1, h=1, center=false) {
  translate(-[0, 0, center ? h/2 : 0])
  difference() {
    cylinder(r=r1, h=h, center=center);
    translate([0, 0, -.1]) {
      cylinder(r=r2, h=h+0.2);
      translate([-r1-0.1, -r1-0.1, 0]) cube([r1*2+.1, r1+.1, h+0.2]);
      rotate([0, 0, -180+a]) translate([-r1-0.1, -r1-0.1, 0]) cube([r1*2+.1, r1+.1, h+0.2]);
    }
  }
}

ball_mount([0, 30, 0]) {
  // color("gold") tee_nut();

  multmatrix(keyboard_offset) {
    color("lightsteelblue") assembled_plate();
    color("lightsteelblue") plate_trim();
    accessories();
  }

  color("forestgreen") cylinder(d=28, h=5.5);

  hull() {
    rotate([0, 0, 200]) arc(r1=14, r2=5, h=5.6, a=60);
    multmatrix(posts[0]) translate([0, 0, -10]) cylinder(d=6, h=5);
  }

  hull() {
    rotate([0, 0, 290]) arc(r1=14, r2=5, h=5.6, a=60);
    multmatrix(posts[1]) translate([0, 0, -10]) cylinder(d=6, h=5);
  }

  hull() {
    rotate([0, 0, 50]) arc(r1=14, r2=5, h=5.6, a=60);
    multmatrix(posts[2]) translate([0, 0, -10]) cylinder(d=6, h=5);
  }

  multmatrix(posts[0]) screw_post();
  multmatrix(posts[1]) screw_post();
  multmatrix(posts[2]) screw_post();

  color("green", alpha=0.4) multmatrix(posts[0]) cylinder(d=3, h=20, center=true);
  color("green", alpha=0.4) multmatrix(posts[1]) cylinder(d=3, h=20, center=true);
  color("green", alpha=0.4) multmatrix(posts[2]) cylinder(d=3, h=20, center=true);
}
