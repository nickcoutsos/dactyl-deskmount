
module nut () {
  c = is_undef($clearance) ? 0 : $clearance;
  across_corners = 12.83;
  height = 5.56;
  cylinder(d=across_corners + c, h=height + c, $fn=6);
}

module bolt() {
  bolt_height = 29.4;
  cap_height = 4.3;
  c = is_undef($clearance) ? 0 : $clearance;
  e = is_undef($extend) ? 0 : $extend;

  translate([0, 0, -c/2]) cylinder(d=6.35 + c, h=bolt_height + c + e);
  translate([0, 0, bolt_height - cap_height - c/2]) cylinder(d=12.47+c, h=cap_height+c + e, $fn=6);
}
