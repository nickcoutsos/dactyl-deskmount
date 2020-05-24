use <../../util.scad>
include <../../switch-and-keycap-specs.scad>

module mx_switch () {
  color("saddlebrown") {
    translate([0, 0, 6]) cube([7, 5.3, 2], center=true);
    translate([0, 0, 6]) cube([4.1, 1.17, 7.2], center=true);
    translate([0, 0, 6]) cube([1.17, 4.1, 7.2], center=true);
  }

  color("gray")
  difference() {
    hull() {
      translate([0, .75, 6]) linear_extrude(height=.01) square([10.25, 9], center=true);
      translate([0, 0, 1]) linear_extrude(height=.01) square(13.97, center=true);
    }

    translate([0, -7, 5]) cube([7.8, 6, 7.5], center=true);
  }

  color("dimgray") {
    mirror_axes([[0, 1, 0]])
    mirror_axes([[1, 0, 0]])
    translate([-13.97/2 - .5, -13.97/2 - .5, 0])
      cube([5, 2, 1]);

    difference() {
      hull() {
        translate([0, 0, 1]) linear_extrude(height=0.01) square(13.97, center=true);
        translate([0, 0, 0]) linear_extrude(height=0.01) square(13.97, center=true);
        translate([0, 0, -5]) linear_extrude(height=0.01) square(12.72, center=true);
      }

      mirror_axes([[1, 0, 0]])
      translate([(mx_keyhole_length - 2.11)/2, 0, -4.55/2])
        cube([2.11, 3.81, 4.55], center=true);
    }

    translate([0, 0, -5 -3]) cylinder(d=4, h=3);
  }

  color("gold") {
    translate([2, 4, 0] * 1.27) translate([0, 0, -5 -3.3]) cylinder(d=1.5, h=3.3);
    translate([-3, 2, 0] * 1.27) translate([0, 0, -5 -3.3]) cylinder(d=1.5, h=3.3);
  }
}
