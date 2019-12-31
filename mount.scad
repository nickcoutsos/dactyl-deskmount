use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

use <placeholders.scad>
use <positioning.scad>
use <util.scad>
use <main.scad>
include <definitions.scad>

$fn = 12;
keyboard_offset = rotation([0, -20, 0]) * translation([30, 10, -10]);

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

module screw_and_nut_cutout() {
  translate([0, 0, 4]) cylinder(d=6, h=3);
  translate([0, 0, -1]) cylinder(d=3, h=6);
  translate([0, 0, -1]) m3_hex_nut($clearance=1);
  m3_hex_nut($clearance=1);
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

mount_base_height = 5.5;

module mount() {
  color("forestgreen") cylinder(d=28, h=mount_base_height);

  color("mediumseagreen")
  multmatrix(keyboard_offset)
  difference() {
    serial_hulls() {
      post_place(0) translate([0, 0, -7 + .01]) cylinder(d=9.5, h=6);
      post_place(0) translate([0, 0, -7 + .01]) cylinder(d=6, h=5);
      post_place(0) translate([6.5, 0, -7 + .01]) cylinder(d=6, h=5);

      multmatrix(invert_rt(keyboard_offset))
      rotate([0, 0, 190])
        arc(r1=14, r2=12, h=mount_base_height, a=70);
    }

    post_place(0) translate([0, 0, -7]) screw_and_nut_cutout();
  }

  color("mediumseagreen")
  multmatrix(keyboard_offset)
  difference() {
    serial_hulls() {
      post_place(1) translate([0, 0, -7 + .01]) cylinder(d=9.5, h=6);
      post_place(1) translate([0, 0, -7 + .01]) cylinder(d=6, h=5);
      multmatrix(finger_place_transformation(1.2, 4)) translate([0, 0, -10]) sphere(r=3);
      multmatrix(finger_place_transformation(1.2, 3)) translate([0, 0, -10]) sphere(r=3.5);
      multmatrix(finger_place_transformation(1.2, 2)) translate([0, 0, -10]) sphere(r=3.5);
      multmatrix(finger_place_transformation(1.2, 1)) translate([0, 0, -10]) sphere(r=3);
      post_place(2) translate([0, 0, -7 + .01]) cylinder(d=6, h=5);
      post_place(2) translate([0, 0, -7 + .01]) cylinder(d=9.5, h=6);
    }

    post_place(1) translate([0, 0, -7]) screw_and_nut_cutout();
    post_place(2) translate([0, 0, -7]) screw_and_nut_cutout();
  }

  color("mediumseagreen")
  multmatrix(keyboard_offset)
  hull() {
    multmatrix(finger_place_transformation(1.2, 3)) translate([0, 0, -10]) sphere(r=3.5);
    multmatrix(finger_place_transformation(1.2, 2)) translate([0, 0, -10]) sphere(r=3.5);
    multmatrix(invert_rt(keyboard_offset))
    rotate([0, 0, -70])
      arc(r1=14, r2=12, h=mount_base_height, a=140);
  }
}

ball_mount([0, 30, 0]) {
  color("gold") tee_nut();
  mount();

  multmatrix(keyboard_offset) {
    color("lightsteelblue") assembled_plate();
    accessories($render_controller=true);

    post_place(0) m3_screw();
    post_place(1) m3_screw();
    post_place(2) m3_screw();

    post_place(0) translate([0, 0, -7]) m3_hex_nut();
    post_place(1) translate([0, 0, -7]) m3_hex_nut();
    post_place(2) translate([0, 0, -7]) m3_hex_nut();
  }
}
