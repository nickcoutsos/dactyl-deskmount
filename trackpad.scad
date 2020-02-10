use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>

use <placeholders.scad>
use <table-hook.scad>

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

trackpad_pivot = [-5, 10, -10];

translate([0, -20, -20])
ball_mount(trackpad_pivot) {
  translate(-[0, 0, 15.05+8.47])
  multmatrix(invert_rt(rotation(trackpad_pivot)))
  table_hook([-26, 20, 20], $render_accessories=true);

  translate([40, -10, 8])
  trackpad(center=true);
}
