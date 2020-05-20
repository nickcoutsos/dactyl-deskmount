
module micro_usb_breakout(center=false, footprint=false) {
  CLEARANCE = is_undef($clearance) ? 0 : $clearance;
  C = [1, 1, 1] * CLEARANCE;
  pcb_dimensions = [12.8, 14.2, 1.67];
  connector_dimensions = [8.1, 5, 3.08];
  connector_offset = [0, 0.98, -0.25];

  translate((center ? [0, 0, pcb_dimensions.z] : pcb_dimensions)/2) {
    color("mediumblue") cube(pcb_dimensions + C, center=true);
    color("silver")
    translate(connector_offset)
    translate([
      0,
      pcb_dimensions.y - connector_dimensions.y,
      pcb_dimensions.z + connector_dimensions.z
    ] / 2) {
      cube(connector_dimensions + C, center=true);
      if (footprint) {
        translate([0, 5, 0])
        cube(connector_dimensions + C + [0, 10, 0], center=true);
      }
    }
  }
}
