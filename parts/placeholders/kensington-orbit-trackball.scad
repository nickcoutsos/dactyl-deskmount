tilt = -14;

module position_mouse() {
  translate([0, 0, 30])
  rotate([0, tilt, 0])
  children();
}

module footprint(height=10) {
  linear_extrude(height=height)
  import("kensington-orbit-footprint.svg", center=true);
}

module trackball(expand=1, height=10) {
  scale([expand, expand, 1]) {
    color("royalblue")
    translate([-138.64/2, 0, 0])
    translate([30.2 + 14.9/2, 0, 0])
    translate([0, 0, 44.5 - 40/2])
    sphere(d=40, $fn=64);

    color("dimgray")
    difference() {
      r=200;
      intersection(){
        rotate([0, 20, 0])
        translate([0, 0, -r])
        translate([138.64/2, 0, 0])
        translate([-60.89, 0, 0])
        translate([0, 0, 33.31])
        rotate([90, 0, 0])
        cylinder(r=r, h=120, $fn=64, center=true);

        footprint(height=30);

        scale([1, 1, 0.6])
        rotate([0, 90, 0])
        cylinder(r=57.5, h=140, center=true);
      }

      l=200;
      translate([138.64/2, 0, 0])
      translate([-60.89, 0, 0])
      translate([0, 0, 33.31])
      rotate([0, -22, 0])
      translate([0, 0, l/2])
      cube(l, center=true);
    }
  }
}

module outline() {
  translate([0, 0, -10])
  scale([1.05, 1.05, 70])
  linear_extrude(height=1)
  projection()
  trackball();
}
