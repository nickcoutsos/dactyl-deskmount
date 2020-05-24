use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>
use <../positioning.scad>
use <../positioning-transformations.scad>
use <../util.scad>
use <../geometry.scad>

use <placeholders/tee-nut.scad>
use <placeholders/m3-hex-nut.scad>

include <../definitions.scad>

mount_base_height = 8.5;

module screw_and_nut_cutout() {
  translate([0, 0, 5]) cylinder(d=6.5, h=3);
  translate([0, 0, -1]) cylinder(d=3, h=6);
  scale([1, 1, 2]) translate([0, 0, -2]) m3_hex_nut($clearance=1);
  m3_hex_nut($clearance=.75);
}

module bottom_mount() {
  difference() {
    union() {
      color("forestgreen") rotate([0, 0, -70]) cylinder(d=28, h=mount_base_height, $fn=24);

      color("mediumseagreen")
      multmatrix(keyboard_offset)
      difference() {
        serial_hulls() {
          post_place(0) translate([0, 0, -7 + .01]) cylinder(d=11, h=6);
          post_place(0) translate([0, 0, -7 + .01]) cylinder(d=6, h=5);
          post_place(0) translate([0, 6.5, -7 + .01]) cylinder(d=6, h=5);

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
          multmatrix(finger_place_transformation(1.2, 3.5)) translate([0, 0, -10]) sphere(r=3.5);
          multmatrix(finger_place_transformation(1.2, 3)) translate([0, 0, -10]) sphere(r=3.5);
          multmatrix(finger_place_transformation(1.2, 2.5)) translate([0, 0, -10]) sphere(r=3.5);
          multmatrix(finger_place_transformation(1.2, 2)) translate([0, 0, -10]) sphere(r=3);
          multmatrix(finger_place_transformation(1.2, 1.5)) translate([0, 0, -10]) sphere(r=3);
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
        multmatrix(finger_place_transformation(1.2, 1.5)) translate([0, 0, -10]) sphere(r=3);
        multmatrix(invert_rt(keyboard_offset))
        rotate([0, 0, -70])
          arc(r1=14, r2=12, h=mount_base_height, a=140, $fn=24);
      }
    }

    tee_nut($clearance=1, footprint=true);
  }
}

bottom_mount($fn=12, $detail=true);
