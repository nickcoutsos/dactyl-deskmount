use <../scad-utils/transformations.scad>
use <../geometry.scad>
use <clamp-knob.scad>
use <clamp-swivel-plate.scad>
use <placeholders/hex-nut-and-bolt.scad>
use <placeholders/nut.scad>
use <placeholders/tee-nut.scad>
use <placeholders/table.scad>
include <../definitions.scad>

default_fn = 12;

clamp_offset = -[0, -16, desk_thickness + 2];
clamp_accessory_base = -4;

module clamp() {
  $fn = is_undef($fn) ? default_fn : $fn;

  hull() {
    translate(-[0, 5, desk_thickness + 17]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
    translate(clamp_offset) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
    translate(clamp_offset + [0, 0, -10]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
    translate([0, 14, -4]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
    truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
  }
}

module clamp_base() {
  $fn = is_undef($fn) ? default_fn : $fn;
  translate(-[0, 5, desk_thickness + 17]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
}

module clamp_cutouts() {
  $fn=24;
  cut_diameter = desk_arm_thickness * 1.5;
  table($clearance=1);
  translate(clamp_offset + [0, 2 -11 + cut_diameter/2, 1]) cylinder(d1=cut_diameter - 2, d2=cut_diameter + 4, h=4, center=true);
  translate([0, 0, clamp_accessory_base]) {
    translate(clamp_offset + [0, 2 -11 + cut_diameter/2, -5]) cylinder(d=cut_diameter, h=12);
    translate(clamp_offset + [0, 2, -5]) rotate([0, 0, 45]) cylinder(d1=19, d2=21, h=1.5, center=true);
    translate(clamp_offset + [0, 2, -14]) rotate([0, 0, 45]) tee_nut($clearance=1);
    translate(clamp_offset + [0, 2, -14]) cylinder(d=6.35+0.5, h=20, center=true);
    translate(clamp_offset + [0, 5, -38]) rotate([0, 90, 0]) cylinder(d=43, h=desk_arm_thickness+1, center=true);
    translate(clamp_offset + [0, 2, -16.5]) cylinder(d1=9, d2=6.35, h=3, center=true);
    translate(clamp_offset + [0, 5+43/2, -38]) cube(43, center=true);
  }
}

module clamp_accessories() {
  color("goldenrod")
  translate(clamp_offset + [0, 2, -14])
  rotate([0, 0, 45])
    tee_nut();

  translate(clamp_offset + [0, 2, 1.75])
  rotate([180, 0, 0]) {
    color("silver") translate([0, 0, 4]) bolt();
    color("slategray") swivel_plate_with_nut();
    color("slategray") translate([0, 0, 34]) rotate([180, 0, 0]) knob();
  }
}

union() {
  $fn=12;
  table();
  difference() {
    clamp();
    clamp_cutouts();
  }

  translate([0, 0, clamp_accessory_base])
  clamp_accessories();
}
