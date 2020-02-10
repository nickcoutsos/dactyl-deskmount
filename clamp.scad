use <scad-utils/transformations.scad>
use <placeholders.scad>
use <util.scad>
include <definitions.scad>

default_fn = 12;

clamp_offset = -[0, -16, desk_thickness + 2];

module clamp() {
  $fn = is_undef($fn) ? default_fn : $fn;

  hull() {
    translate(-[0, 5, desk_thickness + 20]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
    translate(clamp_offset) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
    translate(clamp_offset + [0, 0, -10]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
    translate([0, 10, -4]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
    truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
  }
}

module clamp_base() {
  $fn = is_undef($fn) ? default_fn : $fn;
  translate(-[0, 5, desk_thickness + 20]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
}

module clamp_cutouts() {
  $fn=24;
  cut_diameter = desk_arm_thickness * 1.5;
  table($clearance=1);
  translate(clamp_offset + [0, 2 -11 + cut_diameter/2, -1]) cylinder(d=cut_diameter, h=8, center=true);
  translate(clamp_offset + [0, 2 -11 + cut_diameter/2, 1]) cylinder(d1=cut_diameter - 2, d2=cut_diameter + 4, h=4, center=true);
  translate(clamp_offset + [0, 2, -5]) rotate([0, 0, 45]) cylinder(d1=19, d2=21, h=1.5, center=true);
  translate(clamp_offset + [0, 2, -14]) rotate([0, 0, 45]) tee_nut($clearance=1);
  translate(clamp_offset + [0, 2, -14]) cylinder(d=6.35+0.5, h=20, center=true);
  translate(clamp_offset + [0, 5, -38]) rotate([0, 90, 0]) cylinder(d=43, h=desk_arm_thickness+1, center=true);
  translate(clamp_offset + [0, 2, -16.5]) cylinder(d1=9, d2=6.35, h=3, center=true);
  translate(clamp_offset + [0, 5+43/2, -38]) cube(43, center=true);
}

module bolt() {
  bolt_height = 29.4;
  cap_height = 4.3;
  c = is_undef($clearance) ? 0 : $clearance;
  e = is_undef($extend) ? 0 : $extend;

  translate([0, 0, -c/2]) cylinder(d=6.35 + c, h=bolt_height + c + e);
  translate([0, 0, bolt_height - cap_height - c/2]) cylinder(d=12.47+c, h=cap_height+c + e, $fn=6);
}

module knob() {
  difference() {
    lobed_cylinder(radius=8, h=7);
    translate([0, 0, 29.4]) rotate([180, 0, 0]) color("silver") bolt($clearance=0.5, $extend=5);
  }
}

module swivel_plate() {
  difference() {
    union() {
      cylinder(d=20, h=1.5, $fn=24);
      translate([0, 0, 1.5]) cylinder(d1=18, d2=9, h=5);
    }
    translate([0, 0, 3.5]) bolt($clearance=0.75);
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
    color("slategray") swivel_plate();
    color("slategray") translate([0, 0, 34]) rotate([180, 0, 0]) knob();
  }
}

table();
difference() {
  clamp($fn=12);
  clamp_cutouts();
}

clamp_accessories();
