use <3535-led.scad>
use <hex-nut-and-bolt.scad>
use <ic-socket.scad>
use <keycap.scad>
use <keyswitch.scad>
use <m3-hex-nut.scad>
use <m3-screw.scad>
use <micro-usb-breakout.scad>
use <promicro.scad>
use <tee-nut.scad>
use <trrs-breakout.scad>

module display() {
  for (i=[0:$children-1]) {
    translate([30 * (i - $children/2), 30, 0]) children(i);
  }

  for (i=[0:$children-1]) {
    $detail=true;
    translate([30 * (i - $children/2), 0, 0]) children(i);
  }

  for (i=[0:$children-1]) {
    $detail=true;
    translate([30 * (i - $children/2), -30, 0]) children(i);
  }
  for (i=[0:$children-1]) {
    $detail=true;
    $clearance=1;
    #translate([30 * (i - $children/2), -30, 0]) children(i);
  }
}

display() {
  led();
  hex_nut();
  hex_bolt();
  socket(center=true);
  kailh_choc_keycap();
  kailh_choc_switch();
  m3_hex_nut();
  m3_screw();
  micro_usb_breakout(center=true);
  pro_micro(center=true);
  tee_nut();
  trrs_breakout(center=true);
}
