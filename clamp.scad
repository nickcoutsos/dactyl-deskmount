use <scad-utils/transformations.scad>
use <placeholders.scad>
use <util.scad>
include <definitions.scad>

$fn = 12;

radius = 17.5/2 * 1.25;
clamp_offset = -[0, -16, desk_thickness + 2];

module clamp() {
  hull() {
    translate(-[0, 5, desk_thickness + 20]) truncated_sphere(r=radius);
    translate(clamp_offset) truncated_sphere(r=radius);
    translate(clamp_offset + [0, 0, -10]) truncated_sphere(r=radius);
    translate([0, 10, -4]) truncated_sphere(r=radius);
    truncated_sphere(r=radius);
  }
}

module clamp_base() {
  translate(-[0, 5, desk_thickness + 20]) truncated_sphere(r=radius);
}

module clamp_cutouts() {
  $fn=24;
  table($clearance=1);
  translate(clamp_offset + [0, -1, -1]) cylinder(d=24, h=8, center=true);
  translate(clamp_offset + [0, -1, 1]) cylinder(d1=22, d2=28, h=4, center=true);
  translate(clamp_offset + [0, -1, -5]) rotate([0, 0, 45]) cylinder(d1=19, d2=21, h=1.5, center=true);
  translate(clamp_offset + [0, -1, -14]) rotate([0, 0, 45]) tee_nut($clearance=1);
  translate(clamp_offset + [0, -1, -14]) cylinder(d=6.35, h=20, center=true);
  translate(clamp_offset + [0, 2.5, -32]) rotate([0, 90, 0]) cylinder(d=35, h=20, center=true);
}

module bolt() {
  c = is_undef($clearance) ? 0 : $clearance;
  e = is_undef($extend) ? 0 : $extend;

  translate([0, 0, -c/2]) cylinder(d=6.35 + c, h=25.4 + c + e);
  translate([0, 0, 21.4 - c/2]) cylinder(d=11+c, h=4+c + e, $fn=6);
}

module knob() {
  difference() {
    lobed_cylinder(radius=8, h=6);
    translate([0, 0, 25.4]) rotate([180, 0, 0]) color("silver") bolt($clearance=1, $extend=5);
  }
}

module clamp_accessories() {
  color("goldenrod")
  translate(clamp_offset + [0, -2, -14])
  rotate([0, 0, 45])
    tee_nut();

  translate(clamp_offset + [0, -2, 0])
  rotate([180, 0, 0]) {
    color("slategray") cylinder(d=18, h=1.5, $fn=24);
    color("slategray") translate([0, 0, 1.5]) cylinder(d1=16, d2=8, h=5);
    color("silver") translate([0, 0, 4]) bolt();
    color("slategray") translate([0, 0, 30]) rotate([180, 0, 0]) knob();
  }
}

table();
difference() {
  clamp();
  clamp_cutouts();
}

clamp_accessories();
