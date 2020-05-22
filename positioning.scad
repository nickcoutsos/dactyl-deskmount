use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>
use <positioning-transformations.scad>
include <definitions.scad>

/**
 * Important note:
 * While finger_place and thumb_place should realistically work in the same way,
 * they are currently written expecting that thumb_place parameters are indices
 * to the `thumb_columns` 2d-array while finger_place parameters are the actual
 * column/row positions. This is confusing and should be improved.
 */

/**
 * Position child modules in the given finger column and row.
 *
 * If $u or $h aren't defined in this context they default to 1.
 * @param Number column
 * @param Number row
 */
module finger_place(column, row) {
  $u = is_undef($u) ? 1 : $u;
  $h = is_undef($h) ? 1 : $h;

  transformation = finger_place_transformation(column, row);

  multmatrix(transformation)
    children();
}

/**
 * Position child modules in the given thumb column and row.
 *
 * $u, $h, $rot will be set in this context according to the configured
 * `thumb_overrides` definition.
 *
 * @param Number colIndex
 * @param Number rowIndex
 */
module thumb_place (colIndex, rowIndex) {
  dimensions = get_overrides(thumb_overrides, colIndex, rowIndex);
  $u = dimensions[0];
  $h = dimensions[1];
  $rot = dimensions[2];
  column = colIndex;
  row = thumb_columns[colIndex][rowIndex];

  multmatrix(thumb_place_transformation(column, row))
    children();
}

// The following modules build on the basic {finger/thumb}_place module and
// apply further transforms to position child nodes at the specified cardinal
// direction of the plate, setting sizing context as appropriate.
module finger_corner_nw(col, row, transform=identity4()) { multmatrix(finger_place_transformation(col, row) * transform * key_size_offset(-1, 1)) children(); }
module finger_corner_ne(col, row, transform=identity4()) { multmatrix(finger_place_transformation(col, row) * transform * key_size_offset( 1, 1)) children(); }
module finger_corner_se(col, row, transform=identity4()) { multmatrix(finger_place_transformation(col, row) * transform * key_size_offset( 1,-1)) children(); }
module finger_corner_sw(col, row, transform=identity4()) { multmatrix(finger_place_transformation(col, row) * transform * key_size_offset(-1,-1)) children(); }

module finger_edge_n(col, row, transform=identity4()) { finger_place(col, row) multmatrix(transform) { translate([0, plate_dimensions.y/2*$h, 0]) children(); } }
module finger_edge_e(col, row, transform=identity4()) { finger_place(col, row) multmatrix(transform) { translate([plate_dimensions.x/2*$u, 0, 0]) children(); } }
module finger_edge_s(col, row, transform=identity4()) { finger_place(col, row) multmatrix(transform) { translate([0, -plate_dimensions.y/2*$h, 0]) children(); } }
module finger_edge_w(col, row, transform=identity4()) { finger_place(col, row) multmatrix(transform) { translate([-plate_dimensions.x/2*$u, 0, 0]) children(); } }

module thumb_corner_nw(col, row) { thumb_place(col, row) translate([(is_undef($u) ? 1 : $u) * -plate_dimensions.x/2, (is_undef($h) ? 1 : $h) * plate_dimensions.y/2, 0]) children(); }
module thumb_corner_ne(col, row) { thumb_place(col, row) translate([(is_undef($u) ? 1 : $u) * plate_dimensions.x/2, (is_undef($h) ? 1 : $h) * plate_dimensions.y/2, 0]) children(); }
module thumb_corner_se(col, row) { thumb_place(col, row) translate([(is_undef($u) ? 1 : $u) * plate_dimensions.x/2, (is_undef($h) ? 1 : $h) * -plate_dimensions.y/2, 0]) children(); }
module thumb_corner_sw(col, row) { thumb_place(col, row) translate([(is_undef($u) ? 1 : $u) * -plate_dimensions.x/2, (is_undef($h) ? 1 : $h) * -plate_dimensions.y/2, 0]) children(); }

module thumb_edge_n(col, row) { $length = is_undef($u) ? 1 : $u * plate_dimensions.y; thumb_place(col, row) translate([0, (is_undef($h) ? 1 : $h) * plate_dimensions.y/2, 0]) children(); }
module thumb_edge_e(col, row) { $length = is_undef($h) ? 1 : $h * plate_dimensions.y; thumb_place(col, row) translate([(is_undef($u) ? 1 : $u) * plate_dimensions.x/2, 0, 0]) children(); }
module thumb_edge_s(col, row) { $length = is_undef($u) ? 1 : $u * plate_dimensions.y; thumb_place(col, row) translate([0, (is_undef($h) ? 1 : $h) * -plate_dimensions.y/2, 0]) children(); }
module thumb_edge_w(col, row) { $length = is_undef($h) ? 1 : $h * plate_dimensions.y; thumb_place(col, row) translate([(is_undef($u) ? 1 : $u) * -plate_dimensions.x/2, 0, 0]) children(); }

module led_position(led) { $u=led_size; $h=led_size; multmatrix(led_transformation(led)) children(); }
module led_corner_nw(led) { $u=led_size; $h=led_size; multmatrix(led_corner_transformation_nw(led)) children(); }
module led_corner_ne(led) { $u=led_size; $h=led_size; multmatrix(led_corner_transformation_ne(led)) children(); }
module led_corner_se(led) { $u=led_size; $h=led_size; multmatrix(led_corner_transformation_se(led)) children(); }
module led_corner_sw(led) { $u=led_size; $h=led_size; multmatrix(led_corner_transformation_sw(led)) children(); }
module led_edge_n(led) { $u=led_size; $h=led_size; multmatrix(led_edge_transformation_n(led)) children(); }
module led_edge_e(led) { $u=led_size; $h=led_size; multmatrix(led_edge_transformation_e(led)) children(); }
module led_edge_s(led) { $u=led_size; $h=led_size; multmatrix(led_edge_transformation_s(led)) children(); }
module led_edge_w(led) { $u=led_size; $h=led_size; multmatrix(led_edge_transformation_w(led)) children(); }

module post_place(index) {
  multmatrix(post_place_transformation(index)) children();
}
