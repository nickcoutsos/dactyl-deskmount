include <../../definitions.scad>

module table() {
  c = [1, 1, 1] * (is_undef($clearance) ? 0 : $clearance);
  r = 1.5;

  surface_depth = desk_available_depth*1.5;
  color("gray") translate([0, desk_available_depth, 0]) translate([0, 25, -20]) cube([400, 50, 20], center=true);
  color("tan") {
    translate([0, r -c.y/2, -r + c.z/2]) rotate([0, 90, 0]) cylinder(r=r, h=400, center=true);
    translate([0, r -c.y/2, -desk_thickness + r - c.z/2]) rotate([0, 90, 0]) cylinder(r=r, h=400, center=true);
    translate([0, r, 0]) translate([0, surface_depth, -desk_thickness] / 2) cube([400, surface_depth, desk_thickness] + c, center=true);
    translate([0, r, 0]) translate([0, 0, -desk_thickness] / 2) cube([400, 2*r, desk_thickness - 2*r] + c, center=true);
  }
}
