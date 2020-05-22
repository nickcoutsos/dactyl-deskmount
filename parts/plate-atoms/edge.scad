include <../../definitions.scad>

module plate_edge(horizontal=false) {
  length = horizontal
    ? plate_dimensions.x * (is_undef($u) ? 1 : $u)
    : plate_dimensions.y * (is_undef($h) ? 1 : $h);

  translate([0, 0, -plate_thickness/2])
  cube([ horizontal ? length : .01, !horizontal ? length : .01, plate_thickness], center=true);
}
