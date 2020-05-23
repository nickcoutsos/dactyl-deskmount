use <../../scad-utils/transformations.scad>
use <../../scad-utils/linalg.scad>

dimensions = [160, 114.9, 10.9];
radius = 7;

module trackpad(center=false) {
  offset = [dimensions.x, dimensions.y, 0] / 2;
  translate(center ? -offset : [0, 0, 0])
  difference() {
    hull() {
      translate([radius, radius, 0]) cylinder(r=radius, h=20);
      translate([radius, dimensions.y-radius, 0]) cylinder(r=radius, h=20);
      translate([dimensions.x-radius, radius, 0]) cylinder(r=radius, h=20);
      translate([dimensions.x-radius, dimensions.y-radius, 0]) cylinder(r=radius, h=20);
    }

    rotate([0, 90, 0])
    rotate([0, 0, 90])
    translate([0, 0, -0.5])
    linear_extrude(height=dimensions.x+1)
    polygon(points=[
      [0, 4.9],
      [dimensions.y, dimensions.z],
      [dimensions.y+1, dimensions.z],
      [dimensions.y+1, dimensions.z + 10],
      [-1, dimensions.z + 10],
      [-1, 4.9],
    ]);
  }
}
