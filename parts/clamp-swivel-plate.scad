use <placeholders/hex-nut-and-bolt.scad>

module swivel_plate() {
  difference() {
    union() {
      cylinder(d=20, h=1.5, $fn=24);
      translate([0, 0, 1.5]) cylinder(d1=18, d2=9, h=5);
    }
    translate([0, 0, 3.5]) bolt($clearance=0.75);
  }
}

module swivel_plate_with_nut() {
  difference() {
    union() {
      cylinder(d=20, h=1.5, $fn=24);
      translate([0, 0, 1.5]) cylinder(d1=18, d2=15, h=4);
    }
    translate([0, 0, 3.5]) bolt($clearance=0.75);
    translate([0, 0, 1]) nut();
  }
}
