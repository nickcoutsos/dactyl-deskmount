use <../geometry.scad>
use <placeholders/hex-nut-and-bolt.scad>

module knob() {
  difference() {
    lobed_cylinder(radius=8, h=7);
    translate([0, 0, 29.4]) rotate([180, 0, 0]) color("silver") hex_bolt($clearance=0.5, $extend=5);
  }
}

translate([0, 0, 7])
rotate([180, 0, 0])
knob();
