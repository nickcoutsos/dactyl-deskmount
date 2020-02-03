use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

use <placeholders.scad>
use <positioning.scad>
use <util.scad>
use <main.scad>
include <definitions.scad>

$fn = 12;
keyboard_offset = rotation([0, -20, 0]) * translation([30, 5, -6]);

module tee_nut(footprint=false) {
  $fn=26;
  clearance = is_undef($clearance) ? 0 : $clearance;
  height = 8.98;
  prongs = [3.5, 1.58, 7.75];
  diameter = 19;

  translate([0, 0, height])
  translate([0, 0, clearance/2])
  rotate([180, 0, 0]) {
    translate([0, 0, clearance/4]) cylinder(d=diameter + clearance/2, h=1.35 + clearance/2);
    translate([0, 0, clearance/4]) cylinder(d=7.7 + clearance/2, h=height + clearance/2);
    translate([0, 0, clearance/4]) cylinder(d1=10 + clearance/2, d2=7.7 + clearance/2, h=2 + clearance/2);
    rotate([0, 0, 90*1]) translate([(diameter)/2-prongs.x/2, -0.5, prongs.z/2+clearance/2]) cube(prongs + [1,1,1] * clearance/2, center=true);
    rotate([0, 0, 90*2]) translate([(diameter)/2-prongs.x/2, -0.5, prongs.z/2+clearance/2]) cube(prongs + [1,1,1] * clearance/2, center=true);
    rotate([0, 0, 90*3]) translate([(diameter)/2-prongs.x/2, -0.5, prongs.z/2+clearance/2]) cube(prongs + [1,1,1] * clearance/2, center=true);
    rotate([0, 0, 90*4]) translate([(diameter)/2-prongs.x/2, -0.5, prongs.z/2+clearance/2]) cube(prongs + [1,1,1] * clearance/2, center=true);
  }

  if (footprint) {
    translate([0, 0, height-1])
    cylinder(
      d1=diameter + clearance/2,
      d2=diameter + 5 + clearance/2,
      h=5
    );
  }
}

module screw_and_nut_cutout() {
  translate([0, 0, 5]) cylinder(d=6.5, h=3);
  translate([0, 0, -1]) cylinder(d=3, h=6);
  scale([1, 1, 2]) translate([0, 0, -2]) m3_hex_nut($clearance=1);
  m3_hex_nut($clearance=.75);
}

mount_base_height = 8.5;

module mount() {
  color("forestgreen") cylinder(d=28, h=mount_base_height, $fn=24);

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
      post_place(1) translate([0, 0, -7 + .01]) cylinder(d=11, h=6);
      post_place(1) translate([0, 0, -7 + .01]) cylinder(d=6, h=5);
      multmatrix(finger_place_transformation(1.2, 4)) translate([0, 0, -10]) sphere(r=3);
      multmatrix(finger_place_transformation(1.2, 3)) translate([0, 0, -10]) sphere(r=3.5);
      multmatrix(finger_place_transformation(1.2, 2)) translate([0, 0, -10]) sphere(r=3.5);
      multmatrix(finger_place_transformation(1.2, 1)) translate([0, 0, -10]) sphere(r=3);
      post_place(2) translate([0, 0, -7 + .01]) cylinder(d=6, h=5);
      post_place(2) translate([0, 0, -7 + .01]) cylinder(d=11, h=6);
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

module table() {
  translate([0, 50, 40]) {
    color("tan") translate([0, 60, -12.99/2]) cube([400, 120, 12.99], center=true);
    color("gray") translate([0, 68.98, 0]) translate([0, 25, -20]) cube([400, 50, 20], center=true);
  }
}

module table_hook() {
  difference() {
    triangle_hulls() {
      rotate(90, Z)
      rotate(60, X)
      rotate(180, Z)
      translate([0, 0, -23.98 - 3])
        cylinder(d=28.44 + 10, h=29.26 -5 +1);

      translate([-20-6, 20, -5]) rotate([0, -12*0, 0]) rotate([10, 0, 0]) truncated_sphere(r=9.375);
      translate([-26, 45, 5]) rotate([60, 0, 0]) truncated_sphere(r=9.375);
      translate([-26, 70, 25]) rotate([90, 0, 0]) truncated_sphere(r=9.375);
      translate([-26, 50, 40]) rotate([0, 0, 0]) truncated_sphere(r=9.375);
    }

    translate([0, 50, 40]) {
      color("tan") translate([0, 60, -12.99/2]) cube([400, 120, 12.99], center=true);
      color("gray") translate([0, 68.98, 0]) translate([0, 25, -15]) cube([400, 50, 30], center=true);
    }

    rotate(90, Z)
    rotate(60, X)
    rotate(180, Z)
    translate([0, 0, -23.98]) {
      translate([0, 10.39 + 4, 0]/2) cylinder(d=4, h=40, center=true);
      translate([0, 10.39 + 4, 0]/-2) cylinder(d=4, h=40, center=true);
      cylinder(d=6.35, h=40, center=true);
      translate([0, 0, 0]) cylinder(d=28.44 + 1, h=29.26 +1);
      translate([0, 0, -3]) rotate([180, 0, 0]) cylinder(d=30, h=15);
      translate([0, (28.44 + 6)/2, 22])
      rotate([90, 0, 0])
        cylinder(d=20, h=15, center=true);
    }
  }
}

// mirror_axes([[1, 0, 0]]) translate([80, 0, 0])
ball_mount([0, 30, 0]) {
  color("gold") tee_nut();
  mount();

  translate(-[0, 0, 15.05+8.47])
  rotate([0, -30, 0])
  table_hook();

  multmatrix(keyboard_offset) {
    assembled_plate($detail=false);
    accessories(
      $render_controller=true,
      $render_leds=true,
      $render_switches=true,
      $render_keycaps=true,
      $render_trrs=true,
      $key_pressed=false
    );

    for (i=[0:2]) post_place(i) {
      m3_screw();
      translate([0, 0, -7]) m3_hex_nut();
    }
  }
}

/// samples for test prints
// intersection() {
//   difference() {
//     mount();
//     tee_nut($clearance=1, footprint=true);
//     multmatrix(keyboard_offset) assembled_plate();
//   }
//   // nut holder
//   // #translate([10, -42, 22]) cylinder(d=12, h=12, center=true);
//   // base
//   // #translate([0, 0, -1]) cylinder(d=30, h=15);
// }
