use <../scad-utils/linalg.scad>
use <../scad-utils/transformations.scad>

use <../geometry.scad>
use <../positioning.scad>
use <../positioning-transformations.scad>
use <../util.scad>
include <../definitions.scad>

use <led-diffuser.scad>
use <socket-mount.scad>
use <plate-atoms/switch-plate.scad>
use <plate-atoms/corner.scad>
use <plate-atoms/edge.scad>
use <plate-atoms/led-sockets.scad>
use <plate-atoms/trim.scad>
use <placeholders/m3-screw.scad>
use <placeholders/choc-keycap.scad>
use <placeholders/choc-switch.scad>
use <placeholders/3535-led.scad>
use <placeholders/ic-socket.scad>
use <placeholders/mx-switch.scad>
use <placeholders/promicro.scad>
use <placeholders/trrs-breakout.scad>
use <placeholders/micro-usb-breakout.scad>
use <placeholders/xda-keycap.scad>

$fn = 12;
$key_pressed = false;
$render_all = false;
$render_switches = false;
$render_keycaps = false;
$render_controller = false;
$render_leds = false;
$render_trrs = false;
$render_usb = false;
$render_diffuser = false;

module switch() {
  if (switch_type == "choc") kailh_choc_switch();
  if (switch_type == "mx") mx_switch();
}

module keycap() {
  if (keycap_type == "choc") kailh_choc_keycap();
  if (keycap_type == "xda") xda_keycap();
}

module position_trrs() {
  multmatrix(thumb_place_transformation(1.5, 1.5))
  rotate([0, 5, 0])
  rotate([81, 0, 0])
  translate([-5.25, -20, -0.5])
    rotate([0, 0, 180])
    children();
}

module position_usb_port() {
  multmatrix(thumb_place_transformation(1.5, 1.5))
  rotate([0, 5, 0])
  rotate([81, 0, 0])
  translate([8, -19, -0.5])
    rotate([0, 0, 180])
    children();
}

module plate() {
  for (colIndex=[0:len(finger_columns) - 1]) {
    for (rowIndex=[0:len(finger_columns[colIndex]) - 1]) {
      finger_key(colIndex, rowIndex) switch_plate();
    }
  }

  for (colIndex=[0:len(thumb_columns)-1]) {
    rows = thumb_columns[colIndex];
    for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
      thumb_place(colIndex, rowIndex) switch_plate();
    }
  }

  for (colIndex=[0:len(finger_columns)-1]) {
    for (rowIndex=[0:len(finger_columns[colIndex])-2]) {
      // this_row = finger_columns[colIndex][rowIndex];
      // next_row = finger_columns[colIndex][rowIndex+1];

      hull() {
        finger_key_edge_s(colIndex, rowIndex) plate_edge(horizontal=true);
        finger_key_edge_n(colIndex, rowIndex + 1) plate_edge(horizontal=true);
      }
    }
  }

  for (colIndex=[0:len(finger_columns)-2]) {
    this_column = finger_columns[colIndex];
    next_column = finger_columns[colIndex+1];

    for (rowIndex=[0:len(finger_columns[colIndex]) - 1]) {
      this = [colIndex, this_column[rowIndex]];
      down = [colIndex, this_column[rowIndex+1]];
      right = [colIndex+1, next_column[rowIndex]];
      down_right = [colIndex+1, next_column[rowIndex+1]];

      if (!is_undef(right.y)) triangle_hulls() {
        finger_key_corner_ne(colIndex, rowIndex) plate_corner();
        finger_key_corner_nw(colIndex+1, rowIndex) plate_corner();
        finger_key_corner_se(colIndex, rowIndex) plate_corner();
        finger_key_corner_sw(colIndex+1, rowIndex) plate_corner();

        if (!is_undef(down.y))
          finger_key_corner_ne(colIndex, rowIndex+1) plate_corner();
        if (!is_undef(down_right.x) && !is_undef(down_right.y))
          finger_key_corner_nw(colIndex+1, rowIndex+1) plate_corner();
        else if (!is_undef(down.y))
          finger_key_corner_se(colIndex, rowIndex+1) plate_corner();
      }
    }
  }

  for (colIndex=[0:len(thumb_columns)-1]) {
    rows = thumb_columns[colIndex];
    for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
      thumb_place(colIndex, rowIndex) switch_plate();
    }

    if (len(rows) > 1) for (rowIndex=[0:len(rows)-2]) {
      this_row = rows[rowIndex];
      next_row = rows[rowIndex+1];

      hull() {
        thumb_edge_n(colIndex, rowIndex) plate_edge(horizontal=true);
        thumb_edge_s(colIndex, rowIndex+1) plate_edge(horizontal=true);
      }
    }
  }

  triangle_hulls() {
    thumb_corner_ne(2, 2) plate_corner();
    thumb_corner_nw(1, 1) plate_corner();
    thumb_corner_se(2, 2) plate_corner();
    thumb_corner_sw(1, 1) plate_corner();
    thumb_corner_ne(2, 1) plate_corner();
    thumb_corner_nw(1, 0) plate_corner();
    thumb_corner_se(2, 1) plate_corner();
    thumb_edge_w(1, 0) plate_corner();
    thumb_corner_ne(2, 0) plate_corner();
    thumb_corner_sw(1, 0) plate_corner();
    thumb_corner_se(2, 0) plate_corner();
  }

  hull() {
    thumb_edge_w(0, 0) plate_edge();
    thumb_edge_e(1, 0) plate_edge();
  }

  triangle_hulls() {
    thumb_edge_e(0, 0) plate_corner();
    finger_corner_sw(1, 4) plate_corner();
    thumb_corner_ne(0, 0) plate_corner();
    finger_corner_nw(1, 4) plate_corner();
  }
  triangle_hulls() {
    finger_corner_nw(1, 4) plate_corner();
    finger_corner_sw(1, 3) plate_corner();
    thumb_corner_ne(0, 0) plate_corner();
    finger_corner_sw(0, 3) plate_corner();
    thumb_corner_nw(0, 0) plate_corner();
    thumb_corner_ne(1, 0) plate_corner();
  }
  triangle_hulls() {
    thumb_corner_ne(1, 0) plate_corner();
    thumb_corner_se(1, 1) plate_corner();
    finger_corner_sw(0, 3) plate_corner();
    hull() {
      thumb_corner_ne(1, 1) plate_corner();

      thumb_corner_ne(1, 1)
      translate([0, 0, -plate_thickness * 1.5])
      rotate([0, 30, 0])
      translate([0, 0, plate_thickness * 1.5])
      scale([1, 1, 1.5])
        plate_corner();

      thumb_corner_ne(1, 1)
      translate([0, 0, -plate_thickness * 1.5])
      rotate([0, 60, 0])
      translate([0, 0, plate_thickness * 1.5])
        plate_corner();
    }
    finger_corner_nw(0, 3) plate_corner();
  }
}

module accessories() {
  for (colIndex=[0:len(finger_columns)-1]) {
    for (rowIndex=[0:len(finger_columns[colIndex])-1]) {
      if ($render_switches || $render_all) finger_key(colIndex, rowIndex) switch();
      if ($render_keycaps || $render_all) finger_key(colIndex, rowIndex) color("white") keycap();
    }
  }

  for (colIndex=[0:len(thumb_columns)-1]) {
    rows = thumb_columns[colIndex];
    for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
      if ($render_switches || $render_all) thumb_place(colIndex, rowIndex) switch();
      if ($render_keycaps || $render_all) thumb_place(colIndex, rowIndex) color("white") keycap();
    }
  }

  if ($render_leds || $render_all)
  for (i=[0:len(leds)-1]) led_position(i) translate([0, 0, -6]) led();

  if ($render_controller || $render_all) {
    pcb_socket_mount() {
      socket(center=true);
      translate([0, 0, 2]) pro_micro(center=true);
    }
  }

  if ($render_trrs || $render_all) {
    position_trrs() trrs_breakout(center=true);
  }

  if ($render_usb || $render_all) {
    position_usb_port() micro_usb_breakout(center=true);
  }

  if ($render_diffuser || $render_all) {
    color("ivory", alpha=0.7) led_diffuser();
  }
}

module assembled_plate() {
  detail = is_undef($detail) ? false : $detail;

  difference() {
    union() {
      plate();
      plate_trim();
      led_sockets();
    }

    if (detail) {
      post_place(0) m3_screw($clearance=1, footprint=true);
      post_place(1) m3_screw($clearance=1, footprint=true);
      post_place(2) m3_screw($clearance=1, footprint=true);
      post_place(3) m3_screw($clearance=1, footprint=true);
      post_place(4) m3_screw($clearance=1, footprint=true);
      position_trrs() trrs_breakout(center=true, $clearance=0.5);
      position_usb_port() micro_usb_breakout($clearance=0.5, center=true, footprint=true);
    }
  }
}

assembled_plate($detail=true);
// plate();
// plate_trim();
accessories($render_all=true);

/// samples for test prints
// intersection() {
//   assembled_plate($detail=true);
//   // keys
//   // #translate([-9, 11, 15]) cube([40, 40, 24], center=true);
//   // keys, first two rows
//   // #union() {
//   //   for (col=[0:5], row=[1,2]) finger_place(col, row) cube(25, center=true);
//   // }
//   // thumb cluster
//   // #thumb_place(1, 0) translate([0, 10, 5]) cube([60, 70, 20], center=true);
//   // screw hole
//   // #translate([-11, -51, 29]) cylinder(d=12, h=12, center=true);
//   // leds
//   // #serial_hulls() {
//   //   finger_edge_n(leds[0].x, leds[0].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[0].x, leds[0].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_n(leds[1].x, leds[1].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[1].x, leds[1].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_n(leds[2].x, leds[2].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[2].x, leds[2].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_n(leds[3].x, leds[3].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[3].x, leds[3].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_n(leds[4].x, leds[4].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[4].x, leds[4].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -2.7]) cube([12, 4, 6], center=true);
//   // }
//   // trrs mount
//   // multmatrix(thumb_place_transformation(1.5, 1.5))
//   // rotate([0, 5, 0])
//   // rotate([81, 0, 0])
//   // translate([2, -19.5, .8])
//   //   cube([32, 18, 8], center=true);
//   // usb breakout
//   // multmatrix(finger_place_transformation(0.5, 0.5)) translate([0, 0, -7]) rotate([-20, 0, 0]) cube([16, 10, 10], center=true);
// }
