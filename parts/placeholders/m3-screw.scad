
module m3_screw(footprint=false) {
  clearance = is_undef($clearance) ? 0 : $clearance;
  head_diameter = 5.85 + clearance;

  color("silver") {
    cylinder(d=head_diameter, h=1.7 + clearance/2);
    translate([0,  0, 1.7 + clearance/4]) cylinder(d1=head_diameter, d2=3 + clearance, h=0.8 + clearance/4);
    translate([0, 0, -11.75 - clearance/4]) cylinder(d=3 + clearance, h=11.75 + clearance/2);
  }

  if (footprint) {
    cylinder(
      d1=head_diameter,
      d2=head_diameter+2,
      h=5
    );
  }
}
