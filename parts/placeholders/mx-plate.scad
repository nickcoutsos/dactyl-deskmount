use <../../util.scad>
include <../../definitions.scad>
include <../../switch-and-keycap-specs.scad>

module mx_plate () {
  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  rot = !is_undef($rot) ? $rot : 0;

  width = u * plate_dimensions.x;
  depth = h * plate_dimensions.y;
  height = plate_dimensions.z;

  render() {
    mirror_axes([[1, 0, 0]])
    translate([mx_keyhole_length - 2.11, 0, -height] / 2)
      cube([2.11, 3.81, height], center=true);

    difference() {
      translate([0, 0, -height/2])
      cube([width, depth, height], center=true);
      cube(mx_keyhole_length, center=true);

      rotate([0, 0, rot])
      translate([0, 0, -2-1.5])
        cube([4, mx_keyhole_length+2, 4], center=true);
    }
  }
}
