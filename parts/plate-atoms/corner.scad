include <../../definitions.scad>

module plate_corner() {
  translate([0, 0, -plate_thickness/2]) cube([.01, .01, plate_thickness], center=true);
}
