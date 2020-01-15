include <definitions.scad>

module choc_keycap(height=3.5) {

  u = !is_undef($u) ? $u : 1;
  h = !is_undef($h) ? $h : 1;
  scoop = max(0, min(1, is_undef($scoop) ? 0 : $scoop));

  width = 17.6 * u;
  depth = 16.6 * h;
  thickness = 1.5;

  top = !is_undef($key_pressed) && $key_pressed == true ? 2.18 : (cap_top_height - height);

  detail = is_undef($detail) ? false : $detail;

  sphere_radius = (1 - scoop) * 150;
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
    scoop_offset_x = u * (is_undef($scoop_offset_x) ? 0 : $scoop_offset_x);
    scoop_offset_y = h * (is_undef($scoop_offset_y) ? 0 : $scoop_offset_y);
    scale([u, h, 1])
    translate([0, 0, sphere_offset + sphere_radius])
    translate([scoop_offset_y, scoop_offset_y, 0])
    rotate([90, 0, 0])
    sphere(r=sphere_radius, $fa=1);
  }

  module bump() {
    translate([0, 0, sphere_offset])
    translate([0, 0, sphere_radius - .25])
    translate([0, 0, -sphere_radius])
    difference() {
      sphere(d=2, $fn=48);
      translate([0, 0, -1]) cube(2, center=true);
    }
  }

  translate([0, 0, top])
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
  // original
  // choc_keycap();

  // deep scoop
  // choc_keycap(height=3.8, $scoop=0.81);

  // deep w/ bump
  choc_keycap(height=3.8, $scoop=0.81, $bump=true);

  // thumb
  // choc_keycap($u=2, $scoop_offset_y=-4);

  // translate([5, 0, 2]) cube([10, 20, 8], center=true);
}
