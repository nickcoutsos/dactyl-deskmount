include <../../definitions.scad>

module ball_mount(
  pivot_transform=ball_mount_pivot_orientation,
  base_transform=ball_mount_base_orientation
) {
  $inverse_base_transform = invert_rt(base_transform);
  $inverse_pivot_transform = invert_rt(pivot_transform);

  multmatrix(base_transform) {
    translate([0, 0, -23.98])
    color("dimgray")
    difference() {
      cylinder(d=28.44, h=29.26);
      translate([0, 0, 20]) cylinder(d=18.88, h=10);
      translate([0, 0, 21.55 + 4]) rotate([90, 0, 0]) sphere(r=12);
      translate([0, 0, 21.55 + 4]) rotate([90, 0, 0]) cylinder(d=8, h=20);
      translate([0, -10, 21.55 + 8]) cube([8, 10, 8], center=true);
      translate([0, 10.39 + 4, 0]/2) cylinder(d=4, h=5, center=true);
      translate([0, 10.39 + 4, 0]/-2) cylinder(d=4, h=5, center=true);
      cylinder(d=6.35, h=4, center=true);
    }

    translate([0, 0, -23.98])
    translate([0, 0, 10.72+5.82/2]) rotate([-90, 0, 0]) {
      color("silver") cylinder(d=5.82, h=21.45);
      color("dimgray") translate([0, 0, 43.44-28.44+10.36/2]) cylinder(d=12.51, h=10.36);
      color("dimgray") translate([0, 0, 43.44-28.44+10.36]) cube([25.84, 5.09, 10.36], center=true);
    }
  }

  multmatrix(pivot_transform) {
    color("silver") sphere(r=11);
    color("silver") cylinder(d=5, h=30.23);
    color("dimgray") translate([0, 0, 15.05]) cylinder(d=28.88, h=8.47);
    translate([0, 0, 15.05+8.47]) children();
  }
}


ball_mount() { color("red", alpha=0.4) cylinder(d=40, h=4); }
