use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

use <placeholders.scad>
use <positioning.scad>
use <util.scad>
include <definitions.scad>

$fn = 12;
$key_pressed = false;
$render_all = false;
$render_switches = false;
$render_keycaps = false;
$render_controller = false;
$render_leds = false;
$render_trrs = false;
$render_usb = false;

led_transform = rotation([0, -60, 0]);
led_offset = [-6, 0, 0];
led_size = 0.52;
leds = [
  [-0.75, 0.82],
  [-0.75, 1.2],
  [-0.75, 1.58],
  [-0.75, 2.34],
  [-0.75, 1.96],
];

module fillet(r, h, center=false) {
  linear_extrude(height=h)
  difference() {
    square([r, r]);
    translate([r, r, 0]) circle(r);
  }
}

module position_trrs() {
  multmatrix(thumb_place_transformation(1, 1.5))
  translate([-2, -6, -14.5])
  rotate([65, 0, 0])
  rotate([0, 0, 164.5])
  rotate([0, 0, 0])
  translate([0, 0.2, -0.25])
    children();
}

module position_usb_port() {
  multmatrix(finger_place_transformation(0.5, 1))
  translate([0, 5, -7.5])
  rotate([-18, 0, 0])
    children();
}

module screw_post() {
  outer = 11;
  depth = 4;
  translate([0, depth / 2, 1]) cube([outer, depth, 4], center=true);
  translate([0, 0, -2]) cylinder(d=5.5, h=3);
  translate([0, 0, -1]) rotate([0, 0, 180]) arc(180, r1=outer/2, r2=0, h=4);
}

module screw_cutout() {
  cylinder(d=3, h=plate_thickness*4, center=true);
  cylinder(d=4.5, h=5);
  translate([0, 0, 2]) cylinder(d1=3, d2=7, h=5, center=true);
}

module plate() {
  for (col=[0:len(finger_columns)-1]) {
    for (row=finger_columns[col]) {
      finger_place(col, row) kailh_choc_plate();
    }
  }

  for (colIndex=[0:len(thumb_columns)-1]) {
    rows = thumb_columns[colIndex];
    for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
      thumb_place(colIndex, rowIndex) kailh_choc_plate();
    }
  }

  for (col=[0:len(finger_columns)-1]) {
    for (rowIndex=[0:len(finger_columns[col])-2]) {
      this_row = finger_columns[col][rowIndex];
      next_row = finger_columns[col][rowIndex+1];

      hull() {
        finger_edge_s(col, this_row) plate_edge(horizontal=true);
        finger_edge_n(col, next_row) plate_edge(horizontal=true);
      }
    }
  }

  for (col=[0:len(finger_columns)-2]) {
    this_column = finger_columns[col];
    next_column = finger_columns[col+1];

    for (rowIndex=[0:len(finger_columns[col]) - 1]) {
      this = [col, this_column[rowIndex]];
      down = [col, this_column[rowIndex+1]];
      right = [col+1, next_column[rowIndex]];
      down_right = [col+1, next_column[rowIndex+1]];

      if (right.y) triangle_hulls() {
        finger_corner_ne(this.x, this.y) plate_corner();
        finger_corner_nw(right.x, right.y) plate_corner();
        finger_corner_se(this.x, this.y) plate_corner();
        finger_corner_sw(right.x, right.y) plate_corner();

        if (down.y) finger_corner_ne(down.x, down.y) plate_corner();
        if (down_right.x && down_right.y) finger_corner_nw(down_right.x, down_right.y) plate_corner();
        else if (down.y) finger_corner_se(down.x, down.y) plate_corner();
      }
    }
  }

  for (colIndex=[0:len(thumb_columns)-1]) {
    rows = thumb_columns[colIndex];
    for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
      thumb_place(colIndex, rowIndex) kailh_choc_plate();
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
  for (col=[0:len(finger_columns)-1]) {
    for (row=finger_columns[col]) {
      if ($render_switches || $render_all) finger_place(col, row) kailh_choc_switch();
      if ($render_keycaps || $render_all) finger_place(col, row) color("white") kailh_choc_keycap();
    }
  }

  for (colIndex=[0:len(thumb_columns)-1]) {
    rows = thumb_columns[colIndex];
    for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
      if ($render_switches || $render_all) thumb_place(colIndex, rowIndex) kailh_choc_switch();
      if ($render_keycaps || $render_all) thumb_place(colIndex, rowIndex) color("white") kailh_choc_keycap();
    }
  }

  if ($render_leds || $render_all)
  for (pos=leds) {
    $fn=12;
    $u = led_size;
    $h = led_size;

    finger_place(pos.x, pos.y)
    multmatrix(led_transform)
    translate(led_offset)
    translate([0, 0, -6])
      led();
  }

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
}

module plate_trim() {
  detail = is_undef($detail) ? false : $detail;

  // connect led column in corner between index column and thumb cluster
  triangle_hulls() {
    finger_corner_ne(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    finger_corner_nw(0, 1) plate_corner();
    finger_corner_se(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    finger_edge_w(0, 1) plate_corner();
    finger_corner_ne(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    finger_corner_sw(0, 1) plate_corner();
    finger_corner_se(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    finger_corner_nw(0, 2) plate_corner();
    finger_corner_ne(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    finger_edge_w(0, 2) plate_corner();
    finger_corner_se(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    finger_edge_w(0, 2) plate_corner();
    finger_corner_ne(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    finger_corner_sw(0, 2) plate_corner();
    finger_corner_se(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    finger_corner_nw(0, 3) plate_corner();
  }

  hull() {
    finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_edge(horizontal=true);
    thumb_corner_nw(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    thumb_corner_ne(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
  }

  triangle_hulls() {
    thumb_corner_nw(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
    thumb_corner_ne(2, 2) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    thumb_corner_nw(2, 2)
    translate([10, -1, -15])
    translate([0, 0, -plate_thickness*1.5])
    translate([0, 0, plate_thickness])
    rotate([-90, 0, 0])
      plate_corner();
    thumb_corner_nw(2, 2) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
  }

  serial_hulls(close=false) {
    // top left corner
    finger_corner_nw(0, 1) edge_profile(90);
    finger_corner_ne(0, 1) edge_profile(90);

    // top edge
    finger_corner_nw(1, 1) edge_profile(90);
    finger_edge_n(1, 1) edge_profile(90);
    finger_corner_ne(1, 1) edge_profile(45, stretch=true);
    finger_corner_nw(2, 1) edge_profile(60);
    finger_corner_ne(2, 1) edge_profile(120);
    finger_corner_nw(3, 1) edge_profile(110);
    finger_corner_ne(3, 1) edge_profile(120);
    finger_corner_nw(4, 1) edge_profile(135, stretch=true);
    finger_corner_ne(4, 1) edge_profile(90);
    finger_corner_nw(5, 1) edge_profile(90);

    // top right corner
    finger_corner_ne(5, 1) edge_profile(110);
    finger_corner_ne(5, 1) edge_profile(140);

    // right edge
    finger_corner_se(5, 1) edge_profile(180);
    finger_corner_ne(5, 2) edge_profile(180);
    finger_corner_se(5, 2) edge_profile(180);
    finger_corner_ne(5, 3) edge_profile(180);
    finger_corner_se(5, 3) edge_profile(180);

    // bottom right corner
    finger_corner_se(5, 3) edge_profile(210);
    finger_corner_se(5, 3) edge_profile(240);

    // bottom edge
    finger_corner_sw(5, 3) edge_profile(270);
    finger_corner_se(4, 3) edge_profile(270);
    finger_corner_sw(4, 3) edge_profile(270-45, stretch=true);
    finger_corner_se(3, 4) edge_profile(220);
    finger_corner_se(3, 4) edge_profile(270);
    finger_corner_sw(3, 4) edge_profile(270);
    finger_corner_sw(3, 4) edge_profile(300);
    finger_corner_se(2, 4) edge_profile(300);
    finger_corner_sw(2, 4) edge_profile(240);
    finger_corner_se(1, 4) edge_profile(240);
    finger_corner_se(1, 4) edge_profile(270);
    finger_corner_sw(1, 4) edge_profile(235, stretch=true);

    // thumb bottom edge
    thumb_edge_e(0, 0) edge_profile(235, stretch=true);
    thumb_corner_se(0, 0) edge_profile(200);
    thumb_corner_se(0, 0) edge_profile(240);
    thumb_corner_sw(0, 0) edge_profile(270);
    thumb_corner_se(1, 0) edge_profile(270);
    thumb_corner_sw(1, 0) edge_profile(270);
    thumb_corner_se(2, 0) edge_profile(270);
    thumb_corner_sw(2, 0) edge_profile(270);

    // thumb bottom left corner
    thumb_corner_sw(2, 0) edge_profile(300);
    thumb_corner_sw(2, 0) edge_profile(330);
    thumb_corner_nw(2, 0) edge_profile(0);
    thumb_corner_sw(2, 1) edge_profile(0);
    thumb_corner_nw(2, 1) edge_profile(0);
    thumb_corner_sw(2, 2) edge_profile(0);
    thumb_corner_nw(2, 2) edge_profile(0);

    thumb_corner_nw(2, 2) edge_profile(90);
    thumb_corner_ne(2, 2) edge_profile(90);
    thumb_corner_nw(1, 1) edge_profile(90);
    thumb_corner_ne(1, 1) edge_profile(90);

    thumb_corner_ne(1, 1)
    translate([0, 0, -plate_thickness * 1.5])
    rotate([0, 30, 0])
    translate([0, 0, plate_thickness * 1.5])
      edge_profile(90);

    thumb_corner_ne(1, 1)
    translate([0, 0, -plate_thickness * 1.5])
    rotate([0, 60, 0])
    translate([0, 0, plate_thickness * 1.5])
      edge_profile(90);

    hull() {
      finger_corner_se(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
      finger_corner_nw(0, 3) plate_corner();
    }
  }

  serial_hulls() {
    // thumb top left corner
    thumb_corner_nw(2, 2) edge_profile(0);
    thumb_corner_nw(2, 2) edge_profile(30);
    thumb_corner_nw(2, 2) edge_profile(60);
    thumb_corner_nw(2, 2) edge_profile(90);
  }

  serial_hulls() {
    thumb_corner_nw(2, 2)
    translate([0, 0, -plate_thickness*1.5])
    rotate([-90, 0, 0])
    translate([0, 0, plate_thickness])
      edge_profile(0);

    thumb_corner_nw(2, 2)
    translate([10, -1, -15])
    translate([0, 0, -plate_thickness*1.5])
    translate([0, 0, plate_thickness])
    rotate([-90, 0, 0]) {
      edge_profile(30);
      edge_profile(50);
      edge_profile(70);
    }

    // thumb to led column
    finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) rotate([-90, 0, 0]) edge_profile(30);
    finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) rotate([0, 0, 0]) edge_profile(0);
    finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_sw(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_sw(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_sw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(0);
    finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(30);
    finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(60);
    finger_corner_nw(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) edge_profile(90);
    finger_corner_ne(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) rotate([0, 30, 0]) edge_profile(90);
    finger_corner_nw(0, 1) edge_profile(90);
  }

  // color("red", alpha=0.4)
  difference() {
    serial_hulls() {
      finger_edge_n(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -3]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -3]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_n(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -3]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -3]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_n(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -3]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -3]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_n(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -3]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -3]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
    }

    if (detail) {
      for (pos=leds) {
        $fn=12;
        $u = led_size;
        $h = led_size;

        finger_place(pos.x, pos.y)
        multmatrix(led_transform)
        translate(led_offset)
        translate([0, 0, -6])
          led($clearance=0.5, footprint=true);
      }
    }
  }

  post_place(0) screw_post();
  post_place(1) screw_post();
  post_place(2) screw_post();
  post_place(3) screw_post();
  post_place(4) screw_post();

  position_trrs() {
    hull() {
      translate([-6, 1.5, 1.5]) cube([1.25, 11.5, 2.5], center=true);
      translate([-8, 1.5, 0]) cube([1.25, 11, .5], center=true);
    }

    hull() {
      translate([6, 1.5, 1.5]) cube([1.25, 11.5, 2.5], center=true);
      translate([8, 1.5, 0]) cube([1.25, 11, .5], center=true);
    }
  }

  hull() {
    finger_edge_n(1, 1) translate([-1, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    position_usb_port() translate([7.5, 6.5 - plate_thickness/2, 2]) scale([1, 1.5, 1]) rotate([90, 0, 0]) plate_corner();
    finger_corner_nw(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
  }
  hull() {
    finger_corner_nw(1, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    finger_corner_ne(0, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    position_usb_port() translate([7.5, 6.5 - plate_thickness/2, 2]) scale([1, 1.5, 1]) rotate([90, 0, 0]) plate_corner();
    position_usb_port() translate([-7.5, 6.5 - plate_thickness/2, 2]) scale([1, 1.5, 1]) rotate([90, 0, 0]) plate_corner();
  }
  hull() {
    finger_corner_ne(0, 1) translate([0, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    finger_edge_n(0, 1) translate([1, 0, -plate_thickness*1.5]) rotate([90, 0, 0]) plate_corner();
    position_usb_port() translate([-7.5, 6.5 - plate_thickness/2, 2]) scale([1, 1.5, 1]) rotate([90, 0, 0]) plate_corner();
  }
  position_usb_port() translate([0, 6.5 + plate_thickness/4, 0]) cube([15, plate_thickness * 1.5, 4], center=true);
}

module assembled_plate() {
  detail = is_undef($detail) ? false : $detail;

  difference() {
    union() {
      plate();
      plate_trim();
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

module pcb_socket_mount() {
  multmatrix(thumb_place_transformation(0.5, -0.5))
  translate([0, 0, -7.5]) {
    difference() {
      union() {
        difference() {
          cube([34.75, 22, 2], center=true);
          cube([31, 16.5, 4], center=true);
        }

        translate([0, 0, 0])
        cube([34.75, 5, 2], center=true);
      }

      translate([0, 0, -2])
      rotate([180, 0, 0])
        socket(center=true, $clearance=0.5);
    }

    translate([0, 0, -2])
    rotate([180, 0, 0])
      children();
  }

  multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) {
    translate([0, plate_height/2+3, -1]) cube([plate_width, 2, 2], center=true);
    translate([0, -(plate_height/2+3), -1]) cube([plate_width, 2, 2], center=true);
  }

  multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) {
    translate([0, plate_height/2+3, -1]) cube([plate_width, 2, 2], center=true);
    translate([0, -(plate_height/2+3), -1]) cube([plate_width, 2, 2], center=true);
  }

  hull() {
    multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) translate([-(keyhole_length+plate_horizontal_padding/2)/2, 0, -1]) cube([plate_horizontal_padding/2, plate_height+5, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -8]) translate([-33/2, 0, 1]) cube([1.75, 22, 1.75], center=true);
  }
  hull() {
    multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) translate([(keyhole_length+plate_horizontal_padding/2)/2, 0, -1]) cube([plate_horizontal_padding/2, plate_height+5, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -8]) translate([33/2, 0, 1]) cube([1.75, 22, 1.75], center=true);
  }

  hull() {
    multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) translate([-plate_width/2+2, plate_height/2+3, -1]) cube([4, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -8]) translate([-33/2, (22-0.5)/2, 1]) cube([1.75, 0.5, 1.75], center=true);
  }
  hull() {
    multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) translate([plate_width/2-2, plate_height/2+3, -1]) cube([4, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -8]) translate([33/2, (22-0.5)/2, 1]) cube([1.75, 0.5, 1.75], center=true);
  }

  hull() {
    multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) translate([-plate_width/2+2, -(plate_height/2+3), -1]) cube([4, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -8]) translate([-33/2, -(22-0.5)/2, 1]) cube([1.75, 0.5, 1.75], center=true);
  }
  hull() {
    multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) translate([plate_width/2-2, -(plate_height/2+3), -1]) cube([4, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0.5, -0.5)) translate([0, 0, -8]) translate([33/2, -(22-0.5)/2, 1]) cube([1.75, 0.5, 1.75], center=true);
  }

  hull() {
    multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) translate([plate_width/2, plate_height/2+3, -1]) cube([.1, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) translate([-plate_width/2, plate_height/2+3, -1]) cube([.1, 2, 2], center=true);
  }
  hull() {
    multmatrix(thumb_place_transformation(1, -0.5)) translate([0, 0, -plate_thickness]) translate([plate_width/2, -(plate_height/2+3), -1]) cube([.1, 2, 2], center=true);
    multmatrix(thumb_place_transformation(0, -0.5)) translate([0, 0, -plate_thickness]) translate([-plate_width/2, -(plate_height/2+3), -1]) cube([.1, 2, 2], center=true);
  }
}

assembled_plate($detail=true);
// plate();
// plate_trim();
// accessories();

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
//   //   finger_edge_n(leds[0].x, leds[0].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[0].x, leds[0].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_n(leds[1].x, leds[1].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[1].x, leds[1].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_n(leds[2].x, leds[2].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[2].x, leds[2].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_n(leds[3].x, leds[3].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[3].x, leds[3].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_n(leds[4].x, leds[4].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   //   finger_edge_s(leds[4].x, leds[4].y, $u=led_size, $h=led_size) multmatrix(led_transform) translate(led_offset) translate([0, 0, -3]) cube([12, 4, 6], center=true);
//   // }
//   // trrs mount
//   // #position_trrs() cube([15, 18, 8], center=true);
//   // usb breakout
//   // multmatrix(finger_place_transformation(0.5, 0.5)) translate([0, 0, -7]) rotate([-20, 0, 0]) cube([16, 10, 10], center=true);
// }
