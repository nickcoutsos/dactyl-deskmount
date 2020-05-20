module trrs_breakout(center=false) {
  CLEARANCE = is_undef($clearance) ? 0.15 : $clearance;
  C = [1, 1, 1] * CLEARANCE;
  pcb = [11, 12.82, 1.8];
  socket = [6, 12.25, 5];

  translate(center ? [0, 0, 0] : pcb/-2)
  {
    color("red")
    translate([0, 0, pcb.z / 2])
    cube(pcb + C, center=true);

    color("gray")
    translate([0, 0, 1.6/2 + (pcb.z + socket.z) / 2])
    cube(socket + C, center=true);

    color("gray")
    translate([0, 6, 1.6+2.5])
    rotate([-90, 0, 0])
    cylinder(d=5 + CLEARANCE, h=1.77 + CLEARANCE);
  }
}
