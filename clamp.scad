use <scad-utils/transformations.scad>
use <placeholders.scad>
use <util.scad>
include <definitions.scad>

$fn = 12;

radius = 17.5/2 * 1.25;

module clamp() {
  clamp_offset = -[0, -16, desk_thickness + 2];
  difference() {
    hull() {
      translate(-[0, 5, desk_thickness + 20]) truncated_sphere(r=radius);
      translate(clamp_offset) truncated_sphere(r=radius);
      translate(clamp_offset + [0, 0, -10]) truncated_sphere(r=radius);
      translate([0, 10, -4]) truncated_sphere(r=radius);
      truncated_sphere(r=radius);
    }

    table($clearance=1);
    translate(clamp_offset + [0, 0, -1]) cylinder(d=24, h=8, center=true, $fn=24);
    translate(clamp_offset + [0, -2, -14]) rotate([0, 0, 45]) tee_nut($clearance=1);
    translate(clamp_offset + [0, -2, -14]) cylinder(d=6.35, h=20, center=true);
    translate(clamp_offset + [0, 2.5, -32]) rotate([0, 90, 0]) cylinder(d=35, h=20, center=true, $fn=20);
  }

  color("gold") translate(clamp_offset + [0, -2, -14]) rotate([0, 0, 45]) tee_nut($detail=true);

  color("ivory")
  translate(clamp_offset + [0, -2, 0])
  rotate([180, 0, 0]) {
    cylinder(d=18, h=1.5, $fn=24);
    translate([0, 0, 1.5]) cylinder(d1=16, d2=8, h=5);
    translate([0, 0, 5]) cylinder(d=6.35, h=25.4);
    translate([0, 0, 30]) cylinder(d=11, h=4, $fn=6);
  }
}

// table();
clamp();

r = 2;
c = [1, 1, 1] * (is_undef($clearance) ? 0 : $clearance);
surface_depth = desk_available_depth*1.5;
