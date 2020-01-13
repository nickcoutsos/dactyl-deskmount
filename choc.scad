include <definitions.scad>

module choc_keycap() {

  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  rot = !is_undef($rot) ? $rot : 0;

  height = 3.5;
  width = 17.6 * (rot == 90 ? h : u);
  depth = 16.6 * (rot == 90 ? u : h);
  thickness = 1.5;

  top = !is_undef($key_pressed) && $key_pressed == true ? 2.18 : (cap_top_height - height);

  detail = is_undef($detail) ? false : $detail;

  sphere_radius = 150;
  sphere_offset = 2.825;

  module outer() {
    hull() {
      linear_extrude(height=.1) square([width, depth], center=true);
      translate([0, 0, 1.7]) linear_extrude(height=.1) square([width, depth], center=true);
      translate([0, 0.8, height]) linear_extrude(height=.1) square([width - 2.6, depth - 3.4], center=true);
    }
  }

  module inner() {
    translate([0, 0, -thickness/2])
    hull() {
      linear_extrude(height=.1) square([width - thickness*2, depth - thickness*2], center=true);
      translate([0, 0, 1.7]) linear_extrude(height=.1) square([width - thickness*2, depth - thickness*2], center=true);
      translate([0, 0.8, height]) linear_extrude(height=.1) square([width - 2.6 - thickness*2, depth - 3.4 - thickness*2], center=true);
    }
  }

  module scoop() {
    scale([u, h, 1])
    translate([0, 0, sphere_offset + sphere_radius])
    rotate([90, 0, 0])
    sphere(r=sphere_radius, $fa=1);
  }

  module bump() {
    translate([0, 0, sphere_offset])
    translate([0, 0, sphere_radius - .25])
    rotate([-1, 0, 0])
    translate([0, 0, -sphere_radius])
    difference() {
      sphere(d=2, $fn=48);
      translate([0, 0, -1]) cube(2, center=true);
    }
  }

  translate([0, 0, top])
  rotate([0, 0, rot])
  union() {
    difference() {
      union() {
        difference() { outer(); inner(); }
        intersection() { translate([0, 0, -thickness]) scoop(); outer(); }
      }

      scoop();
    }

    legs();
    if (!is_undef($bump) && $bump) bump();
  }
}


module legs() {
  $fn = 48;
  translate([5.7/2,0,-3.4/2+2])difference(){
    cube([1.3,3, 3.4], center= true);
    translate([3.9,0,0])cylinder(d=7,3.4,center = true);
    translate([-3.9,0,0])cylinder(d=7,3.4,center = true);
  }
  translate([-5.7/2,0,-3.4/2+2])difference(){
    cube([1.3,3, 3.4], center= true);
    translate([3.9,0,0])cylinder(d=7,3.4,center = true);
    translate([-3.9,0,0])cylinder(d=7,3.4,center = true);
  }
}

difference() {
  choc_keycap($u=2, $rot=90);
  // translate([5, 0, 2]) cube([10, 20, 8], center=true);
}
