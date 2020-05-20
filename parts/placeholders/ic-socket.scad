module socket(center=false) {
  c = [1, 1, 1] * (is_undef($clearance) ? 0 : $clearance);
  thickness = 3.02;
  rect = [30.55, 17.76, thickness];

  bar = [thickness, 17.76, 2.05];

  translate(center ? [0, 0, 0] : rect/2) {
    color([1,1,1]*.2) {
      translate([0, -(rect.y - thickness) / 2, 0]) cube([rect.x, thickness, rect.z] + c, center=true);
      translate([0, (rect.y - thickness)/2, 0]) cube([rect.x, thickness, rect.z] + c, center=true);

      translate([0, 0, (-rect.z + bar.z)/2]) {
        cube(bar + c, center=true);
        translate([-(rect.x - bar.x)/2, 0, 0]) cube(bar + c, center=true);
        translate([(rect.x - bar.x)/2, 0, 0]) cube(bar + c, center=true);
      }
    }

    translate(-[rect.x, 0, rect.z]/2)
    color("silver") {
      for (i=[1:12]) {
        translate([2.54 * (i - .5), 15.28/2, rect.z]) cube([0.64, 0.64, 0.1] + c, center=true);
        translate([2.54 * (i - .5), 15.28/2, -1.98/2]) cube([0.64, 0.64, 1.98] + c, center=true);
        translate([2.54 * (i - .5), 15.28/2, -4.57/2]) cube([0.30, 0.30, 4.57] + c, center=true);

        translate([2.54 * (i - .5), -15.28/2, rect.z]) cube([0.64, 0.64, 0.1] + c, center=true);
        translate([2.54 * (i - .5), -15.28/2, -1.98/2]) cube([0.64, 0.64, 1.98] + c, center=true);
        translate([2.54 * (i - .5), -15.28/2, -4.57/2]) cube([0.30, 0.30, 4.57] + c, center=true);
      }
    }
  }
}
