include <../../definitions.scad>

module kailh_choc_plate() {
  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  rot = !is_undef($rot) ? $rot : 0;

  width = u * plate_width;
  depth = h * plate_height;

  difference() {
    translate([0, 0, -plate_thickness/2])
    cube([width, depth, plate_thickness], center=true);
    cube(keyhole_length, center=true);

    rotate([0, 0, rot]) {
      translate([0, 3.30, -2-1.125]) cube([keyhole_length+2, 3.5, 4], center=true);
      translate([0, -3.30, -2-1.125]) cube([keyhole_length+2, 3.5, 4], center=true);
    }
  }
}
