use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

use <parts/bottom-mount.scad>
use <parts/table-hook.scad>
use <parts/plate.scad>
use <parts/placeholders/ball-mount.scad>
use <parts/placeholders/m3-hex-nut.scad>
use <parts/placeholders/m3-screw.scad>
use <parts/placeholders/micro-usb-breakout.scad>
use <parts/placeholders/tee-nut.scad>
use <parts/placeholders/promicro.scad>
use <parts/placeholders/table.scad>
use <positioning.scad>
use <util.scad>
include <definitions.scad>

$fn = 12;

// translate(desk_top_offset) table();
// mirror_axes([[1, 0, 0]]) translate([80, 0, 0])
ball_mount() {
  color("goldenrod") tee_nut();
  bottom_mount();

  translate(-[0, 0, 15.05+8.47])
  multmatrix($inverse_pivot_transform)
  table_hook([-26, 0, 0], $render_accessories=true);

  multmatrix(keyboard_offset) {
    assembled_plate($detail=true);
    accessories(
      $render_controller=true,
      $render_leds=true,
      $render_switches=true,
      $render_keycaps=true,
      $render_trrs=true,
      $key_pressed=false
    );

    for (i=[0:2]) post_place(i) {
      m3_screw();
      translate([0, 0, -7]) m3_hex_nut();
    }
  }
}

/// samples for test prints
// intersection() {
//   difference() {
//     mount();
//     tee_nut($clearance=1, footprint=true);
//     multmatrix(keyboard_offset) assembled_plate();
//   }

//   // ball mount socket
//   // table_hook([-26, 0, 0]);
//   // rotate(90, Z)
//   // rotate(60, X)
//   // rotate(180, Z)
//   // translate([0, 0, -25])
//   //   cylinder(d=40, h=10, center=true);

//   // nut holder
//   // #translate([10, -42, 22]) cylinder(d=12, h=12, center=true);
//   // base
//   // #translate([0, 0, -1]) cylinder(d=30, h=15);
// }
