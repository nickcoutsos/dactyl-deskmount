use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>
use <../geometry.scad>
use <../util.scad>
use <clamp.scad>

include <../definitions.scad>

module table_hook(offset=[0, 0, 0]) {
  if (!is_undef($render_accessories) && $render_accessories) {
    translate(offset) translate(desk_top_offset) clamp_accessories();
  }

  difference() {
    union() {
      multmatrix(ball_mount_base_orientation)
      translate([0, 0, -23.98 - 3])
        cylinder(d=ball_mount_diameter + 2*ball_mount_socket_thickness, h=29.26 -5 +1);

      triangle_hulls() {
        multmatrix(ball_mount_base_orientation)
        translate([0, 0, -23.98 - 3])
          cylinder(d=ball_mount_diameter + 2*ball_mount_socket_thickness, h=22 -5 +1);

        translate([-26, 20, -8]) rotate([10, 0, 0]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
        translate([-26, 30, -8]) rotate([10, 0, 0]) truncated_sphere(r=desk_arm_radius, rr=desk_arm_trunc);
        translate(offset) translate(desk_top_offset) clamp_base();
      }

      translate(offset) translate(desk_top_offset) clamp();
    }

    translate(offset) translate(desk_top_offset) clamp_cutouts();

    multmatrix(ball_mount_base_orientation)
    translate([0, 0, -ball_mount_height]) {
      rotate([0, 0, 90]) {
        translate([0, 10.39 + 4, 0]/2) cylinder(d=4.5, h=40, center=true);
        translate([0, 10.39 + 4, 0]/-2) cylinder(d=4.5, h=40, center=true);
      }
      cylinder(d=6.35, h=40, center=true);
      translate([0, 0, 0]) cylinder(d=ball_mount_diameter + 1, h=29.26 +1, $fn=48);
      translate([0, 0, -4]) rotate([180, 0, 0]) cylinder(d=30, h=15);

      translate([0, ball_mount_diameter/2, 18]) {
        cube([10, 10, 10], center=true);
        translate([0, 0, -5]) rotate([90, 0, 0]) cylinder(d=10, h=15, center=true);
      }
    }
  }
}

table_hook([-26, 0, 0], $render_accessories=false, $fn=12);
