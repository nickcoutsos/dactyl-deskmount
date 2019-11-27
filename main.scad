use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

use <placeholders.scad>
use <positioning.scad>
use <util.scad>
include <definitions.scad>

$fn = 8;
$key_pressed = false;

for (col=[0:len(finger_columns)-1]) {
  for (row=finger_columns[col]) {
    finger_place(col, row) kailh_choc_switch();
    finger_place(col, row) color("white") kailh_choc_keycap();
    finger_place(col, row) color("lightsteelblue") kailh_choc_plate();
  }

}

color("lightsteelblue") {
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
}

for (colIndex=[0:len(thumb_columns)-1]) {
  rows = thumb_columns[colIndex];
  for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
    thumb_place(colIndex, rowIndex) kailh_choc_switch();
    thumb_place(colIndex, rowIndex) color("white") kailh_choc_keycap();
    thumb_place(colIndex, rowIndex) color("lightsteelblue") kailh_choc_plate();
  }

  color("lightsteelblue")
  if (len(rows) > 1) for (rowIndex=[0:len(rows)-2]) {
    this_row = rows[rowIndex];
    next_row = rows[rowIndex+1];

    hull() {
      thumb_edge_n(colIndex, rowIndex) plate_edge(horizontal=true);
      thumb_edge_s(colIndex, rowIndex+1) plate_edge(horizontal=true);
    }
  }
}

color("lightsteelblue") {
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
    finger_corner_sw(1, 4) plate_corner();
    thumb_edge_e(0, 0) plate_corner();
    finger_corner_nw(1, 4) plate_corner();
    thumb_corner_ne(0, 0) plate_corner();
    finger_corner_sw(1, 3) plate_corner();
    thumb_corner_nw(0, 0) plate_corner();
    finger_corner_sw(0, 3) plate_corner();
    thumb_corner_ne(1, 0) plate_corner();
    thumb_corner_se(1, 1) plate_corner();
    thumb_corner_ne(1, 1) plate_corner();
    finger_corner_sw(0, 3) plate_corner();
    finger_corner_nw(0, 3) plate_corner();
  }
}

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

for (pos=leds) {
  $fn=12;
  $u = led_size;
  $h = led_size;

  finger_place(pos.x, pos.y)
  multmatrix(led_transform)
  translate(led_offset)
  translate([0, 0, -3])
    led();
}

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
  thumb_corner_ne(1, 1) plate_corner();
}
hull() {
  finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_edge(horizontal=true);
  thumb_corner_nw(1, 1) edge_profile(90);
  thumb_corner_ne(1, 1) rotate([0, 0, 0]) edge_profile(60);
}
triangle_hulls() {
  thumb_corner_nw(1, 1) edge_profile(90);
  finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) plate_corner();
  thumb_corner_ne(2, 2) edge_profile(90);
  thumb_corner_nw(2, 2) edge_profile(90);
}


serial_hulls(close=false) {
  // top left corner
  finger_corner_nw(0, 1) edge_profile(90);
  finger_corner_ne(0, 1) edge_profile(90);

  // top edge
  finger_corner_nw(1, 1) edge_profile(90);
  finger_corner_ne(1, 1) edge_profile(60);
  finger_corner_nw(2, 1) edge_profile(60);
  finger_corner_ne(2, 1) edge_profile(120);
  finger_corner_nw(3, 1) edge_profile(110);
  finger_corner_ne(3, 1) edge_profile(120);
  finger_corner_nw(4, 1) edge_profile(120);
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
  finger_corner_sw(4, 3) edge_profile(240);
  finger_corner_se(3, 4) edge_profile(240);
  finger_corner_se(3, 4) edge_profile(270);
  finger_corner_sw(3, 4) edge_profile(270);
  finger_corner_sw(3, 4) edge_profile(300);
  finger_corner_se(2, 4) edge_profile(300);
  finger_corner_sw(2, 4) edge_profile(240);
  finger_corner_se(1, 4) edge_profile(240);
  finger_corner_se(1, 4) edge_profile(270);
  finger_corner_sw(1, 4) edge_profile(240);

  // thumb bottom edge
  thumb_edge_e(0, 0) edge_profile(200);
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

  // thumb top left corner
  thumb_corner_nw(2, 2) edge_profile(30);
  thumb_corner_nw(2, 2) edge_profile(60);
  thumb_corner_nw(2, 2) edge_profile(90);
  thumb_corner_nw(2, 2)
  translate([0, 0, -plate_thickness*1.5])
  rotate([0, -90, 0])
  translate([0, 0, plate_thickness])
    edge_profile(90);

  // thumb to led column
  finger_corner_sw(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) rotate([-90, 0, 0]) edge_profile(0);
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


ball_mount();
