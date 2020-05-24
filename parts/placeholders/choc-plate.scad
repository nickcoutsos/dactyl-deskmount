include <../../definitions.scad>
include <../../switch-and-keycap-specs.scad>

module kailh_choc_plate() {
  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  rot = !is_undef($rot) ? $rot : 0;

  width = u * plate_dimensions.x;
  depth = h * plate_dimensions.y;
  height = plate_dimensions.z;

  difference() {
    translate([0, 0, -height/2])
    cube([width, depth, height], center=true);
    cube(choc_keyhole_length, center=true);

    rotate([0, 0, rot]) {
      translate([0, 3.30, -2-1.125]) cube([choc_keyhole_length+2, 3.5, 4], center=true);
      translate([0, -3.30, -2-1.125]) cube([choc_keyhole_length+2, 3.5, 4], center=true);
    }
  }
}
