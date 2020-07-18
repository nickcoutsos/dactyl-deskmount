
module m3_hex_nut() {
  center = !is_undef($center) && $center;
  clearance = is_undef($clearance) ? 0 : $clearance;
  detail = !is_undef($detail) && $detail;
  diameter = 6.12 + clearance;
  height = 2.35 + clearance;

  color("silver")
  translate([0, 0, center ? -height/2 : 0])
  cylinder(d=diameter, h=height, $fn=6);
}
