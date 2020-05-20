use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>
use <placeholders/ic-socket.scad>
use <../positioning.scad>
use <../util.scad>
include <../definitions.scad>

mount_top_height = 9.5 + 1;

module pcb_socket_mount() {
  multmatrix(thumb_place_transformation(0.5, -0.5))
  translate([0, 0, -9.5]) {
    difference() {
      union() {
        difference() {
          cube([34.75, 22, 2], center=true);
          cube([31, 16.5, 4], center=true);
        }

        translate([0, 0, 0])
        cube([34.75, 5, 2], center=true);
      }

      translate([0, 0, -2])
      rotate([180, 0, 0])
        socket(center=true, $clearance=0.5);
    }

    translate([0, 0, -2])
    rotate([180, 0, 0])
      children();
  }

  multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) {
    translate([-plate_width/4, plate_height/2+3, -1]) cube([plate_width/2, 2, 2], center=true);
    translate([-plate_width/4, -(plate_height/2+3), -1]) cube([plate_width/2, 2, 2], center=true);
  }

  multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) {
    translate([plate_width/4, plate_height/2+3, -1]) cube([plate_width/2, 2, 2], center=true);
    translate([plate_width/4, -(plate_height/2+3), -1]) cube([plate_width/2, 2, 2], center=true);
  }

  hull() {
    multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) translate([-(keyhole_length+plate_horizontal_padding/2)/2, 0, -1]) cube([plate_horizontal_padding/2, plate_height+5, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -10]) translate([-33/2, 0, 1]) cube([1.75, 22, 1.75], center=true);
  }
  hull() {
    multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) translate([(keyhole_length+plate_horizontal_padding/2)/2, 0, -1]) cube([plate_horizontal_padding/2, plate_height+5, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -10]) translate([33/2, 0, 1]) cube([1.75, 22, 1.75], center=true);
  }

  hull() {
    multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) translate([-plate_width/2+2, plate_height/2+3, -1]) cube([4, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -10]) translate([-33/2, (22-0.5)/2, 1]) cube([1.75, 0.5, 1.75], center=true);
  }
  hull() {
    multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) translate([plate_width/2-2, plate_height/2+3, -1]) cube([4, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -10]) translate([33/2, (22-0.5)/2, 1]) cube([1.75, 0.5, 1.75], center=true);
  }

  hull() {
    multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) translate([-plate_width/2+2, -(plate_height/2+3), -1]) cube([4, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -10]) translate([-33/2, -(22-0.5)/2, 1]) cube([1.75, 0.5, 1.75], center=true);
  }
  hull() {
    multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) translate([plate_width/2-2, -(plate_height/2+3), -1]) cube([4, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -10]) translate([33/2, -(22-0.5)/2, 1]) cube([1.75, 0.5, 1.75], center=true);
  }
}


translate([0, 0, mount_top_height])
multmatrix(invert_rt(thumb_place_transformation(0.5, -0.5)))
pcb_socket_mount();
