
module tee_nut(footprint=false) {
  $fn = is_undef($fn) ? 26 : $fn;
  clearance = is_undef($clearance) ? 0 : $clearance;
  height = 8.98;
  prongs = [3.5, 1.58, 7.75];
  diameter = 19;

  difference() {
    translate([0, 0, height])
    translate([0, 0, clearance/2])
    rotate([180, 0, 0]) {
      translate([0, 0, clearance/4]) cylinder(d=diameter + clearance/2, h=1.35 + clearance/2);
      translate([0, 0, clearance/4]) cylinder(d=7.7 + clearance/2, h=height + clearance/2);
      translate([0, 0, clearance/4]) cylinder(d1=10 + clearance/2, d2=7.7 + clearance/2, h=2 + clearance/2);
      rotate([0, 0, 90*1]) translate([(diameter)/2-prongs.x/2, -0.5, prongs.z/2+clearance/2]) cube(prongs + [1,1,1] * clearance/2, center=true);
      rotate([0, 0, 90*2]) translate([(diameter)/2-prongs.x/2, -0.5, prongs.z/2+clearance/2]) cube(prongs + [1,1,1] * clearance/2, center=true);
      rotate([0, 0, 90*3]) translate([(diameter)/2-prongs.x/2, -0.5, prongs.z/2+clearance/2]) cube(prongs + [1,1,1] * clearance/2, center=true);
      rotate([0, 0, 90*4]) translate([(diameter)/2-prongs.x/2, -0.5, prongs.z/2+clearance/2]) cube(prongs + [1,1,1] * clearance/2, center=true);
    }

    if (!is_undef($detail) && $detail && !footprint) {
      cylinder(d=6.35, h=20, center=true);
    }
  }

  if (footprint) {
    translate([0, 0, height-1])
    cylinder(
      d1=diameter + clearance/2,
      d2=diameter + 5 + clearance/2,
      h=5
    );
  }
}
