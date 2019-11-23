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

module connector() {
  translate([0, 0, -plate_thickness/2]) cube([.01, .01, plate_thickness], center=true);
}

module kailh_choc_switch() {
  rot = !is_undef($rot) ? $rot : 0;
  detail = !is_undef($detail) && $detail;

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

  width = 17.6 * (rot == 90 ? h : u);
  depth = 16.6 * (rot == 90 ? u : h);

  top_width = width - 2.6;
  top_depth = depth - 3.4;

  translate([0, 0, cap_top_height - keycap_height])
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
  CLEARANCE = $clearance == undef ? 0.15 : $clearance;
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

module micro_usb_breakout(center=false) {
  CLEARANCE = $clearance == undef ? 0.15 : $clearance;
  C = [1, 1, 1] * CLEARANCE;
  pcb_dimensions = [12.7, 14.1, 1.8] + C;
  connector_dimensions = [6, 5, 2] + C;

  translate(center ? pcb_dimensions/-2 : [0, 0, 0])
  rotate([0, 0, 180])
  translate(-C/2)
  {
    color("mediumblue") cube(pcb_dimensions);
    color("silver")
    translate([(pcb_dimensions.x - connector_dimensions.x)/2, 0, pcb_dimensions.z])
      cube(connector_dimensions);
  }
}

module socket(center=false) {
  translate(center ? -[33, 17, 1.5]/2 : [0, 0, 0]) {
    color([1,1,1]*.2) {
      translate([0, 0, 0]) cube([33, 2.5, 2]);
      translate([0, 17-2.5, 0]) cube([33, 2.5, 2]);
      translate([0, 0, 0]) cube([2.5, 17, 1.25]);
      translate([15, 0, 0]) cube([2.5, 17, 1.25]);
      translate([33-2.5, 0, 0]) cube([2.5, 17, 1.25]);
    }

    color("silver") {
      for (i=[1:13]) {
        translate([2.54 * (i - .5), 2.54/2, 0.5]) cube([0.64, 0.64, 3.5], center=true);
        translate([2.54 * (i - .5), 2.54/2, -2]) cube([0.30, 0.30, 4], center=true);

        translate([0, 17, 0])
        mirror([0, 1, 0]) {
          translate([2.54 * (i - .5), 2.54/2, 0.5]) cube([0.64, 0.64, 3.5], center=true);
          translate([2.54 * (i - .5), 2.54/2, -2]) cube([0.30, 0.30, 4], center=true);
        }
      }
    }
  }
}

module trrs_breakout(center=false) {
  CLEARANCE = $clearance == undef ? 0.15 : $clearance;
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
