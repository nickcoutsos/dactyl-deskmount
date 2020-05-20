module kailh_choc_switch() {
  rot = !is_undef($rot) ? $rot : 0;
  detail = !is_undef($detail) && $detail;
  height = !is_undef($key_pressed) && $key_pressed == true ? -2.18 : 0;

  rotate([0, 0, rot]) {
    color("lightgray") translate([0, 0, 1.4]) cube([13.8, 13.8, 2.8], center=true);
    color("lightgray") translate([0, 6.9, 0.4]) cube([15.0, 1.2, 0.8], center=true);
    color("lightgray") translate([0, -6.9, 0.4]) cube([15.0, 1.2, 0.8], center=true);
    color("dimgray")
    difference() {
      translate([0, 0, -1.1]) cube([13.8, 13.8, 2.2], center=true);
      if (detail) {
        translate([0, 4.4, -1]) cube([5, 3.15, 3], center=true);
      }
    }
    color("dimgray") translate([0, 0, -2.2]) rotate([180, 0, 0]) cylinder(d=3.4, h=2.65);
    color("yellow") translate([0, -5.9, -2.2]) rotate([180, 0, 0]) cylinder(d=1.2, h=2.65);
    color("yellow") translate([5, -3.8, -2.2]) rotate([180, 0, 0]) cylinder(d=1.2, h=2.65);

    color("saddlebrown")
    translate([0, 0, height])
    translate([0, 0, 2.5+1.5+.3])
    difference() {
      cube([12, 5.5, 3], center=true);
      if (detail) {
        translate([-5.7/2, 0, 0]) cube([1.2, 3.0, 5], center=true);
        translate([5.7/2, 0, 0]) cube([1.2, 3.0, 5], center=true);
      }
    }
  }
}
