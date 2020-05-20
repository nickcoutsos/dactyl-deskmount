module pro_micro(center=false) {
  CLEARANCE = is_undef($clearance) ? 0.15 : $clearance;
  C = [1, 1, 1] * CLEARANCE;
  pcb_dimensions = [33.27, 18.22, 1.5];
  socket_dimensions = [0.64, 0.64, 1.6];
  connector_dimensions = [8, 7.56, 2.4];

  translate(center ? [0, 0, 0] : -(pcb_dimensions)/2) {
    color("midnightblue") cube(pcb_dimensions + C, center=true);
    color("silver") {
      translate([
        -pcb_dimensions.x/2 + connector_dimensions.x/2 - 1,
        0,
        pcb_dimensions.z/2 + connector_dimensions.z/2 - 0.1
      ]) cube(connector_dimensions + C, center=true);

      for (i=[1:12]) {
        translate([-pcb_dimensions.x/2 + 2.54 * (i + .5), 2.54/2 - pcb_dimensions.y/2, 0]) cube(socket_dimensions + C, center=true);
        translate([-pcb_dimensions.x/2 + 2.54 * (i + .5), -2.54/2 + pcb_dimensions.y/2, 0]) cube(socket_dimensions + C, center=true);
      }
    }
  }
}
