
module vector(v, length, r=.5) {
  x = v.x;
  y = v.y;
  z = v.z;
  length_ = norm(v);
  length = is_undef(length) ? length_ : length;

  if (length_ > 0) {
    theta = atan2(x, -y); // equator angle around z-up axis
    phi = acos( min( max(z / length_, -1), 1) ); // polar angle

    rotate([0, 0, theta])
    rotate([phi, 0, 0]) {
      cylinder(r1=r, r2=r * .8, h=length * .95);
      translate([0, 0, length * .95])
        cylinder(r1=r * .8, r2=0, h=length * .05);
    }
  }
}

module axes(length=30) {
  color("coral") vector([1, 0, 0] * length);
  color("mediumseagreen") vector([0, 1, 0] * length);
  color("blue") vector([0, 0, 1] * length);
}
