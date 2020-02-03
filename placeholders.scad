include <definitions.scad>

module vector(v, r=.5) {
  x = v[0];
  y = v[1];
  z = v[2];

  length = norm(v);
  theta = atan2(x, -y); // equator angle around z-up axis
  phi = acos( min( max(z / length, -1), 1) ); // polar angle

  rotate([0, 0, theta])
  rotate([phi, 0, 0]) {
    cylinder(r1=r, r2=r * .8, h=length * .95);
    translate([0, 0, length * .95])
      cylinder(r1=r * .8, r2=0, h=length * .05);
  }
}

module axes(length=30) {
  color("red") vector([1, 0, 0] * length);
  color("limegreen") vector([0, 1, 0] * length);
  color("royalblue") vector([0, 0, 1] * length);
}

module plate_corner() {
  translate([0, 0, -plate_thickness/2]) cube([.01, .01, plate_thickness], center=true);
}

module plate_edge(horizontal=false) {
  length = horizontal
    ? plate_width * (is_undef($u) ? 1 : $u)
    : plate_height * (is_undef($h) ? 1 : $h);

  translate([0, 0, -plate_thickness/2])
  cube([ horizontal ? length : .01, !horizontal ? length : .01, plate_thickness], center=true);
}

module kailh_choc_switch() {
  rot = !is_undef($rot) ? $rot : 0;
  detail = !is_undef($detail) && $detail;
  height = !is_undef($key_pressed) && $key_pressed == true ? -2.18 : 0;

  rotate([0, 0, rot]) {
    color("lightgray") translate([0, 0, 1.4]) cube([13.8, 13.8, 2.8], center=true);
    color("lightgray") translate([0, 6.9, 0.4]) cube([15.0, 1.2, 0.8], center=true);
    color("lightgray") translate([0, -6.9, 0.4]) cube([15.0, 1.2, 0.8], center=true);
    color("dimgray")
    difference() {
      translate([0, 0, -1.1]) cube([13.8, 13.8, 2.2], center=true);
      if (detail) {
        translate([0, 4.4, -1]) cube([5, 3.15, 3], center=true);
      }
    }
    color("dimgray") translate([0, 0, -2.2]) rotate([180, 0, 0]) cylinder(d=3.4, h=2.65);
    color("yellow") translate([0, -5.9, -2.2]) rotate([180, 0, 0]) cylinder(d=1.2, h=2.65);
    color("yellow") translate([5, -3.8, -2.2]) rotate([180, 0, 0]) cylinder(d=1.2, h=2.65);

    color("saddlebrown")
    translate([0, 0, height])
    translate([0, 0, 2.5+1.5+.3])
    difference() {
      cube([12, 5.5, 3], center=true);
      if (detail) {
        translate([-5.7/2, 0, 0]) cube([1.2, 3.0, 5], center=true);
        translate([5.7/2, 0, 0]) cube([1.2, 3.0, 5], center=true);
      }
    }
  }
}

module kailh_choc_keycap() {
  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  rot = !is_undef($rot) ? $rot : 0;
  height = !is_undef($key_pressed) && $key_pressed == true ? 2.18 : (cap_top_height - keycap_height);

  width = 17.6 * (rot == 90 ? h : u);
  depth = 16.6 * (rot == 90 ? u : h);

  top_width = width - 2.6;
  top_depth = depth - 3.4;

  translate([0, 0, height])
  rotate([0, 0, rot])
  difference() {
    hull() {
      linear_extrude(height=.1) square([width, depth], center=true);
      translate([0, 0, 1.7]) linear_extrude(height=.1) square([width, depth], center=true);
      translate([0, 0.8, 3.5]) linear_extrude(height=.1) square([top_width, top_depth], center=true);
    }

    if (!is_undef($detail) && $detail) {
      translate([0, 0, 3 +90])
      rotate([90, 0, 0])
      scale([u, 1, h])
      sphere(r=90, $fa=1);
    }
  }
}

module kailh_choc_plate() {
  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  rot = !is_undef($rot) ? $rot : 0;

  width = u * plate_width;
  depth = h * plate_height;

  difference() {
    translate([0, 0, -plate_thickness/2])
    cube([width, depth, plate_thickness], center=true);
    cube(keyhole_length, center=true);

    rotate([0, 0, rot]) {
      translate([0, 3.30, -2-1.125]) cube([keyhole_length+2, 3.5, 4], center=true);
      translate([0, -3.30, -2-1.125]) cube([keyhole_length+2, 3.5, 4], center=true);
    }
  }
}

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

module jr_connector(pin_count) {
  color([0.1, 0.1, 0.1])
  translate([-2.6/2, -2.6/2, 0])
  cube([2.4*pin_count + 2.6/2, 2.6, 14.1]);
}

module micro_usb_breakout(center=false, footprint=false) {
  CLEARANCE = is_undef($clearance) ? 0.15 : $clearance;
  C = [1, 1, 1] * CLEARANCE;
  pcb_dimensions = [12.7, 14.1, 1.8];
  connector_dimensions = [6, 5, 2];

  translate(center ? [0, 0, 0] : pcb_dimensions/2)
  rotate([0, 0, 180])
  {
    color("mediumblue") cube(pcb_dimensions + C, center=true);
    color("silver")
    translate([
      0,
      -pcb_dimensions.y + connector_dimensions.y,
      pcb_dimensions.z + connector_dimensions.z
    ] / 2) {
      cube(connector_dimensions + C, center=true);
      if (footprint) {
        translate([0, -5, 0])
        cube(connector_dimensions + C + [0, 10, 0], center=true);
      }
    }
  }
}

module socket(center=false) {
  c = [1, 1, 1] * (is_undef($clearance) ? 0 : $clearance);
  thickness = 3.02;
  rect = [30.55, 17.76, thickness];

  bar = [thickness, 17.76, 2.05];

  translate(center ? [0, 0, 0] : rect/2) {
    color([1,1,1]*.2) {
      translate([0, -(rect.y - thickness) / 2, 0]) cube([rect.x, thickness, rect.z] + c, center=true);
      translate([0, (rect.y - thickness)/2, 0]) cube([rect.x, thickness, rect.z] + c, center=true);

      translate([0, 0, (-rect.z + bar.z)/2]) {
        cube(bar + c, center=true);
        translate([-(rect.x - bar.x)/2, 0, 0]) cube(bar + c, center=true);
        translate([(rect.x - bar.x)/2, 0, 0]) cube(bar + c, center=true);
      }
    }

    translate(-[rect.x, 0, rect.z]/2)
    color("silver") {
      for (i=[1:12]) {
        translate([2.54 * (i - .5), 15.28/2, rect.z]) cube([0.64, 0.64, 0.1] + c, center=true);
        translate([2.54 * (i - .5), 15.28/2, -1.98/2]) cube([0.64, 0.64, 1.98] + c, center=true);
        translate([2.54 * (i - .5), 15.28/2, -4.57/2]) cube([0.30, 0.30, 4.57] + c, center=true);

        translate([2.54 * (i - .5), -15.28/2, rect.z]) cube([0.64, 0.64, 0.1] + c, center=true);
        translate([2.54 * (i - .5), -15.28/2, -1.98/2]) cube([0.64, 0.64, 1.98] + c, center=true);
        translate([2.54 * (i - .5), -15.28/2, -4.57/2]) cube([0.30, 0.30, 4.57] + c, center=true);
      }
    }
  }
}

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

module header_pins(pin_count, right_angle=false, reverse=false) {
  for (i=[1:pin_count]) {
    color("gray") translate([2.54 * (i - 1) - 1.2, -1.2, 0]) cube([2.4, 2.4, 2.5]);

    color("gold")
    translate([2.54 * (i - 1), 0, 0])
    rotate([0, 0, reverse ? 180 : 0])
    translate([-0.32, -0.32, 0]) {
      translate([0, 0, -2.5]) cube([0.64, 0.64, 2.5]);

      if (!right_angle) {
        translate([0, 0, 2.5]) cube([0.64, 0.64, 5]);
      } else {
        translate([0, 0, 2.5]) cube([0.64, 0.64, 2]);

        translate([0, 0.64, 4.5])
        rotate([45, 0, 0])
        translate([0, -0.64, 0])
        cube([0.64, 0.64, 1]);

        translate([0, 0.64, 4.5])
        rotate([45, 0, 0])
        translate([0, 0, 1])
        rotate([45, 0, 0])
        translate([0, -0.64, 0])
        cube([0.64, 0.64, 6.5]);
      }
    }
  }
}

module edge_profile(rot=0) {
  rotate([0, 0, -rot])
  difference() {
    union() {
      translate([0, 0, -plate_thickness]) rotate([90, 0, 0]) cylinder(r=plate_thickness, h=.01, center=true);
      translate([0, 0, -plate_thickness*1.5]) cube([plate_thickness*2, .01, plate_thickness], center=true);
    }

    translate([plate_thickness/2, 0, -plate_thickness]) cube([plate_thickness+.01, .1, plate_thickness*2+.01], center=true);
    translate([0, 0, -plate_thickness*1.75]) cube([plate_thickness*2+.01, .1, plate_thickness/2], center=true);
  }
}

module ball_mount(pivot=[0, 0, 0]) {
  rotate(90, Z)
  rotate(60, X)
  rotate(180, Z) {
    translate([0, 0, -23.98])
    color("dimgray")
    difference() {
      cylinder(d=28.44, h=29.26);
      translate([0, 0, 20]) cylinder(d=18.88, h=10);
      translate([0, 0, 21.55 + 4]) rotate([90, 0, 0]) sphere(r=12);
      translate([0, 0, 21.55 + 4]) rotate([90, 0, 0]) cylinder(d=8, h=20);
      translate([0, -10, 21.55 + 8]) cube([8, 10, 8], center=true);
      translate([0, 10.39 + 4, 0]/2) cylinder(d=4, h=5, center=true);
      translate([0, 10.39 + 4, 0]/-2) cylinder(d=4, h=5, center=true);
      cylinder(d=6.35, h=4, center=true);
    }

    translate([0, 0, -23.98])
    translate([0, 0, 10.72+5.82/2]) rotate([-90, 0, 0]) {
      color("silver") cylinder(d=5.82, h=21.45);
      color("dimgray") translate([0, 0, 43.44-28.44+10.36/2]) cylinder(d=12.51, h=10.36);
      color("dimgray") translate([0, 0, 43.44-28.44+10.36]) cube([25.84, 5.09, 10.36], center=true);
    }
  }

  rotate(pivot) {
    color("silver") sphere(r=11);
    color("silver") cylinder(d=5, h=30.23);
    color("dimgray") translate([0, 0, 15.05]) cylinder(d=28.88, h=8.47);
    translate([0, 0, 15.05+8.47]) children();
  }
}

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

module m3_hex_nut() {
  center = !is_undef($center) && $center;
  clearance = is_undef($clearance) ? 0 : $clearance;
  detail = !is_undef($detail) && $detail;
  diameter = 6.12 + clearance;
  height = 2.35 + clearance;

  color("dimgray")
  translate([0, 0, center ? -height/2 : 0])
  difference() {
    cylinder(d=diameter, h=height, $fn=6);
    if (detail) {
      translate([0, 0, -0.1]) cylinder(d=3.1, h=height + .2);
    }
  }
}

module m3_screw(footprint=false) {
  clearance = is_undef($clearance) ? 0 : $clearance;
  head_diameter = 5.85 + clearance;

  color("dimgray") {
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
