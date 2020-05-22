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
    led_corner_ne(0) plate_corner(); finger_corner_nw(0, 1) plate_corner();
    led_corner_se(0) plate_corner(); finger_edge_w(0, 1) plate_corner();
    led_corner_ne(1) plate_corner(); finger_corner_sw(0, 1) plate_corner();
    led_corner_se(1) plate_corner(); finger_corner_nw(0, 2) plate_corner();
    led_corner_ne(2) plate_corner(); finger_edge_w(0, 2) plate_corner();
    led_corner_se(2) plate_corner(); finger_edge_w(0, 2) plate_corner();
    led_corner_ne(3) plate_corner(); finger_corner_sw(0, 2) plate_corner();
    led_corner_se(3) plate_corner(); finger_corner_nw(0, 3) plate_corner();
  }

  difference() {
    // "plates" in which to mount ws2812 PCBs
    serial_hulls() {
      led_edge_n(0) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(0) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_n(1) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(1) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_n(2) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(2) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_n(3) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(3) translate([0, 0, -2.7]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(3) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-30, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(3) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-60, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(3) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-90, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(3) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-120, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(3) translate([0, 0, plate_thickness*.75/2 -3]) rotate([-140, 0, 0]) translate([0, 0, -plate_thickness*.75/2]) scale([1.2, 1, 0.75]) plate_edge(horizontal=true);
      led_edge_s(3) rotate([0, 0, 0]) plate_edge(horizontal=true);
    }

    if (!is_undef($detail) && $detail) {
      $fn=12;
      for (i=[0:len(leds)-1]) {
        led_position(i)
        translate([0, 0, -5.7])
          led($clearance=0.5, footprint=true);
      }
    }
  }
}
