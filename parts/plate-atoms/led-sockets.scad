use <../../scad-utils/linalg.scad>
use <../../scad-utils/transformations.scad>
use <../../geometry.scad>
use <../../positioning.scad>
use <../../util.scad>
use <corner.scad>
use <edge.scad>
use <../placeholders/3535-led.scad>

include <../../definitions.scad>

module led_sockets() {
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

  difference() {
    serial_hulls() {
      finger_edge_n(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[0].x, leds[0].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_n(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[1].x, leds[1].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_n(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[2].x, leds[2].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_n(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-30, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-60, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-90, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-120, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-140, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      finger_edge_s(leds[3].x, leds[3].y, led_transform, $u=led_size, $h=led_size) translate(led_offset) rotate([0, 0, 0]) plate_edge(horizontal=true);
    }

    if (!is_undef($detail) && $detail) {
      for (pos=leds) {
        $fn=12;
        $u = led_size;
        $h = led_size;

        finger_place(pos.x, pos.y)
        multmatrix(led_transform)
        translate(led_offset)
        translate([0, 0, -5.7])
          led($clearance=0.5, footprint=true);
      }
    }
  }
}
