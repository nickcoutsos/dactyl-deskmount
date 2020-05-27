use <../scad-utils/linalg.scad>
use <../scad-utils/lists.scad>
use <../scad-utils/shapes.scad>
use <../scad-utils/spline.scad>
use <../scad-utils/transformations.scad>
use <../debug-helpers.scad>
use <../positioning.scad>
use <../positioning-transformations.scad>
use <../util.scad>
use <../geometry.scad>

use <placeholders/tee-nut.scad>
use <placeholders/m3-hex-nut.scad>

include <../definitions.scad>

mount_base_height = 8.5;


zero = [0,0,0,1];

thumb_arm_base = translation([-15, -10, 5]) * [0, 0, 0, 1];
thumb_arm_tip = keyboard_offset * post_place_transformation(0) * translation([0, 0, -6]) * [0, 0, 0, 1];
lower_arm_base = keyboard_offset * finger_place_transformation(1.3, 2.5) * translation([0, 0, -11.5]) * zero;
lower_arm_tip = keyboard_offset * post_place_transformation(3) * translation([0, 0, -5]) * zero;
top_arm_base = keyboard_offset * finger_place_transformation(1.3, 2.0) * translation([0, 0, -11.5]) * zero;
top_arm_tip = keyboard_offset * post_place_transformation(4) * translation([0, 0, -5]) * zero;

steps = 6;
profiles = [for (t=[0:steps]) circle(pow((1 - t/steps), 2) * 1.5 + 3, $fn=12)];

module screw_and_nut_cutout() {
  translate([0, 0, 5]) cylinder(d=6.5, h=3);
  translate([0, 0, -1]) cylinder(d=3, h=6);
  scale([1, 1, 2]) translate([0, 0, -2]) m3_hex_nut($clearance=1);
  m3_hex_nut($clearance=.75);
}

module bezier_sweep(control_points, profiles, debug=false) {
  control_points = [ for (v=control_points) take3(v) ];
  bezier = bezier3_args(control_points, symmetric=true);
  total = len(bezier);
  steps = len(profiles) - 1;
  step = total / steps;

  if (debug) {
    for (i=[0:2:len(control_points)-2]) {
      color("gold") translate(control_points[i]) sphere(r=3);
      color("blue", alpha=0.4) translate(control_points[i]) vector(control_points[i+1]);
    }
    for(t=[0:0.05:len(bezier)]) translate(spline(bezier, t))
      sphere(r=0.25, $fn=4);
  }

  color(alpha=debug ? 0.4 : 1)
  for (t=[0:steps - 1])
  serial_hulls() {
    multmatrix(spline_transform(bezier, step * (t+0))) linear_extrude(height=0.1) polygon(profiles[t+0]);
    multmatrix(spline_transform(bezier, step * (t+1))) linear_extrude(height=0.1) polygon(profiles[t+1]);
  }
}

module bottom_mount() {
  difference() {
    union() {
      color("forestgreen") rotate([0, 0, -70]) cylinder(d=28, h=mount_base_height, $fn=24);

      color("mediumseagreen")
      union() {
        hull() {
          rotate([0, 0, 190]) arc(r1=14, r2=12, h=mount_base_height, a=70);
          translate(take3(thumb_arm_base)) sphere(r=4.5);
        }

        bezier_sweep([ thumb_arm_base, [-15, 0, 0], thumb_arm_tip, [-5, -1, -10] ], profiles);

        multmatrix(keyboard_offset)
        serial_hulls() {
          post_place(0) translate([0, 0, -7 + .01]) cylinder(d=11, h=6);
          post_place(0) translate([0, 0, -7 + .01]) cylinder(d=6, h=5);
        }
      }

      color("mediumseagreen")
      multmatrix(keyboard_offset)
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

      color("mediumseagreen")
      union() {
        multmatrix(keyboard_offset) post_place(3) translate([0, 0, -7 + .01]) cylinder(d=11, h=6);
        multmatrix(keyboard_offset) post_place(4) translate([0, 0, -7 + .01]) cylinder(d=11, h=6);
        bezier_sweep([ top_arm_base, [20, 5, 0], top_arm_tip, [10, 20, 12] ], profiles);
        bezier_sweep([ lower_arm_base, [20, -5, 0], lower_arm_tip, [10, -20, 12] ], profiles);
        hull() {
          translate(take3(top_arm_base)) sphere(r=4.5);
          rotate([0, 0, -70]) arc(r1=14, r2=12, h=mount_base_height, a=140, $fn=24);
          translate(take3(lower_arm_base)) sphere(r=4.5);
        }
      }
    }

    tee_nut($clearance=1, footprint=true);

    multmatrix(keyboard_offset) post_place(0) translate([0, 0, -7]) screw_and_nut_cutout();
    multmatrix(keyboard_offset) post_place(1) translate([0, 0, -7]) screw_and_nut_cutout();
    multmatrix(keyboard_offset) post_place(2) translate([0, 0, -7]) screw_and_nut_cutout();
    multmatrix(keyboard_offset) post_place(3) translate([0, 0, -7]) screw_and_nut_cutout();
    multmatrix(keyboard_offset) post_place(4) translate([0, 0, -7]) screw_and_nut_cutout();
  }
}

bottom_mount($fn=12, $detail=true);
