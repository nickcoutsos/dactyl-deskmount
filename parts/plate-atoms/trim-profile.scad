include <../../definitions.scad>

module edge_profile(rot=0, stretch=false) {
  h = sqrt(pow(plate_thickness, 2)*2);
  rotate([0, 0, -rot])
  scale([stretch ? (h / plate_thickness) : 1, 1, 1])
  difference() {
    union() {
      translate([0, 0, -plate_thickness]) rotate([90, 0, 0]) cylinder(r=plate_thickness, h=.01, center=true);
      translate([0, 0, -plate_thickness*1.5]) cube([plate_thickness*2, .01, plate_thickness], center=true);
    }

    translate([plate_thickness/2, 0, -plate_thickness]) cube([plate_thickness+.01, .1, plate_thickness*2+.01], center=true);
    translate([0, 0, -plate_thickness*1.75]) cube([plate_thickness*2+.01, .1, plate_thickness/2], center=true);
  }
}
