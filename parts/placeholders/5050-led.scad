
module led(footprint=false) {
  CLEARANCE = is_undef($clearance) ? 0 : $clearance;
  pcb_thickness = 1.16;
  pcb_diameter = 8;
  led_length = 3.34;
  led_height = 1.04;

  translate([0, 0, pcb_thickness/2]) {
    color([0.25, 0.25, 0.25])
    cylinder(
      d=pcb_diameter + CLEARANCE * 2,
      h=pcb_thickness + CLEARANCE * 2,
      center=true
    );

    color("white")
    translate([0, 0, pcb_thickness / 2 + led_height / 2]) {
      cube([
        led_length + CLEARANCE * 2,
        led_length + CLEARANCE * 2,
        led_height + CLEARANCE * 2
      ], center=true);
    }
  }

  color("silver")
  for (i=[0:2]) {
    translate([(i - 1) * 1.95, -2, 0]) cube([1, 2.18, .05], center=true);
    translate([(i - 1) * 1.95, 2, 0]) cube([1, 2.18, .05], center=true);
  }

  if (footprint) {
    rotate([180, 0, 0]) cylinder(d=pcb_diameter + CLEARANCE*2, h=10);
    translate([0, 0, 5]) {
      cube([
        led_length + CLEARANCE * 2,
        led_length + CLEARANCE * 2,
        10
      ], center=true);
    }

    translate([0, 0, pcb_thickness / 2 + led_height / 2]) {
      cube([
        led_length + 2.5 + CLEARANCE * 2,
        led_length / 2 + CLEARANCE * 2,
        led_height + 1 + CLEARANCE * 2
      ], center=true);
    }
  }
}
