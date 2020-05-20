module arc(a=90, r1=1, r2=1, h=1, center=false) {
  translate(-[0, 0, center ? h/2 : 0])
  difference() {
    cylinder(r=r1, h=h, center=center);
    translate([0, 0, -.1]) {
      cylinder(r=r2, h=h+0.2);
      translate([-r1-0.1, -r1-0.1, 0]) cube([r1*2+.1, r1+.1, h+0.2]);
      rotate([0, 0, -180+a]) translate([-r1-0.1, -r1-0.1, 0]) cube([r1*2+.1, r1+.1, h+0.2]);
    }
  }
}

module truncated_sphere(r=undef, d=undef, rr=0.8) {
  radius = is_undef(r) ? (is_undef(d) ? 2 : d / 2) : r;
  difference() {
    rotate([0, 90, 0]) sphere(radius);
    translate([-radius, 0, 0]) cube([(1 - rr) * radius, radius, radius] * 2, center=true);
    translate([+radius, 0, 0]) cube([(1 - rr) * radius, radius, radius] * 2, center=true);
  }
}

module lobed_cylinder(radius, h=2) {
  lobes = 6;
  translate([0, 0, h/2])
  difference() {
    $fn=24;

    hull()
    for (i=[1:lobes]) {
      rotate([0, 0, i*360/lobes])
      translate([radius, 0, 0]) {
        cylinder(r=radius/5, h=h-1, center=true);
        cylinder(r=0.8*radius/5, h=h, center=true);
      }
    }

    for (i=[1:lobes]) {
      rotate([0, 0, (i-0.5)*360/lobes])
      translate([9/5*radius, 0, 0]) {
        cylinder(r=0.825*radius, h=h+0.1, center=true, $fn=76);
        translate([0, 0, h/2]) cylinder(r1=0.825*radius, r2=1.2*0.825*radius, h=1, center=true, $fn=76);
        translate([0, 0, -h/2]) cylinder(r2=0.825*radius, r1=1.2*0.825*radius, h=1, center=true, $fn=76);
      }
    }
  }
}
