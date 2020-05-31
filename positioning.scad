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
 * Position child modules in the given finger key column and row indices.
 *
 * Overrides for the given key, if available, will set all key special variables
 *   $u, $h, $rot, $xOffset, and $yOffset
 *
 * @param Number columnIndex
 * @param Number rowIndex
 */
module finger_key(colIndex, rowIndex) {
  apply_key_context(finger_overrides, colIndex, rowIndex)
  finger_place(colIndex, finger_columns[colIndex][rowIndex])
    children();
}

/**
 * Position child modules in the given finger column and row.
 *
 * @param Number column
 * @param Number row
 * @param Number [$u=1] key width multiplier
 * @param Number [$h=1] key height multiplier
 */
module finger_place(column, row) {
  $u = is_undef($u) ? 1 : $u;
  $h = is_undef($h) ? 1 : $h;

  multmatrix(finger_place_transformation(column, row))
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
 * @param Number [$u=1] key width multiplier
 * @param Number [$h=1] key height multiplier
 * @param Number [$rot=0] key rotation
 */
module thumb_place (colIndex, rowIndex) {
  column = colIndex;
  row = thumb_columns[colIndex][rowIndex];

  apply_key_context(thumb_overrides, colIndex, rowIndex)
  multmatrix(thumb_place_transformation(column, row))
    children();
}

module apply_key_context(overrides, colIndex, rowIndex) {
  dimensions = get_overrides(overrides, colIndex, rowIndex);
  $u = dimensions[0];
  $h = dimensions[1];
  $rot = dimensions[2];

  $xOffset = dimensions[3];
  $yOffset = dimensions[4];

  children();
}

// The following modules build on the basic {finger/thumb}_place module and
// apply further transforms to position child nodes at the specified cardinal
// direction of the plate, setting sizing context as appropriate.
module finger_key_corner_nw(colIndex, rowIndex) { apply_key_context(finger_overrides, colIndex, rowIndex) multmatrix(finger_corner_transformation_nw(colIndex, finger_columns[colIndex][rowIndex])) children(); }
module finger_key_corner_ne(colIndex, rowIndex) { apply_key_context(finger_overrides, colIndex, rowIndex) multmatrix(finger_corner_transformation_ne(colIndex, finger_columns[colIndex][rowIndex])) children(); }
module finger_key_corner_se(colIndex, rowIndex) { apply_key_context(finger_overrides, colIndex, rowIndex) multmatrix(finger_corner_transformation_se(colIndex, finger_columns[colIndex][rowIndex])) children(); }
module finger_key_corner_sw(colIndex, rowIndex) { apply_key_context(finger_overrides, colIndex, rowIndex) multmatrix(finger_corner_transformation_sw(colIndex, finger_columns[colIndex][rowIndex])) children(); }
module finger_key_edge_n(colIndex, rowIndex)    { apply_key_context(finger_overrides, colIndex, rowIndex) multmatrix(finger_edge_transformation_n(colIndex, finger_columns[colIndex][rowIndex])) children(); }
module finger_key_edge_e(colIndex, rowIndex)    { apply_key_context(finger_overrides, colIndex, rowIndex) multmatrix(finger_edge_transformation_e(colIndex, finger_columns[colIndex][rowIndex])) children(); }
module finger_key_edge_s(colIndex, rowIndex)    { apply_key_context(finger_overrides, colIndex, rowIndex) multmatrix(finger_edge_transformation_s(colIndex, finger_columns[colIndex][rowIndex])) children(); }
module finger_key_edge_w(colIndex, rowIndex)    { apply_key_context(finger_overrides, colIndex, rowIndex) multmatrix(finger_edge_transformation_w(colIndex, finger_columns[colIndex][rowIndex])) children(); }

module finger_corner_nw(col, row) { apply_key_context(finger_overrides, col, row) multmatrix(finger_corner_transformation_nw(col, row)) children(); }
module finger_corner_ne(col, row) { apply_key_context(finger_overrides, col, row) multmatrix(finger_corner_transformation_ne(col, row)) children(); }
module finger_corner_se(col, row) { apply_key_context(finger_overrides, col, row) multmatrix(finger_corner_transformation_se(col, row)) children(); }
module finger_corner_sw(col, row) { apply_key_context(finger_overrides, col, row) multmatrix(finger_corner_transformation_sw(col, row)) children(); }
module finger_edge_n(col, row)    { apply_key_context(finger_overrides, col, row) multmatrix(finger_edge_transformation_n(col, row)) children(); }
module finger_edge_e(col, row)    { apply_key_context(finger_overrides, col, row) multmatrix(finger_edge_transformation_e(col, row)) children(); }
module finger_edge_s(col, row)    { apply_key_context(finger_overrides, col, row) multmatrix(finger_edge_transformation_s(col, row)) children(); }
module finger_edge_w(col, row)    { apply_key_context(finger_overrides, col, row) multmatrix(finger_edge_transformation_w(col, row)) children(); }

module thumb_corner_nw(col, row) { apply_key_context(thumb_overrides, col, row) multmatrix(thumb_corner_transformation_nw(col, row)) children(); }
module thumb_corner_ne(col, row) { apply_key_context(thumb_overrides, col, row) multmatrix(thumb_corner_transformation_ne(col, row)) children(); }
module thumb_corner_se(col, row) { apply_key_context(thumb_overrides, col, row) multmatrix(thumb_corner_transformation_se(col, row)) children(); }
module thumb_corner_sw(col, row) { apply_key_context(thumb_overrides, col, row) multmatrix(thumb_corner_transformation_sw(col, row)) children(); }
module thumb_edge_n(col, row)    { apply_key_context(thumb_overrides, col, row) multmatrix(thumb_edge_transformation_n(col, row)) children(); }
module thumb_edge_e(col, row)    { apply_key_context(thumb_overrides, col, row) multmatrix(thumb_edge_transformation_e(col, row)) children(); }
module thumb_edge_s(col, row)    { apply_key_context(thumb_overrides, col, row) multmatrix(thumb_edge_transformation_s(col, row)) children(); }
module thumb_edge_w(col, row)    { apply_key_context(thumb_overrides, col, row) multmatrix(thumb_edge_transformation_w(col, row)) children(); }

module led_position(led)  { $u=led_size; $h=led_size; multmatrix(led_transformation(led)) children(); }
module led_corner_nw(led) { $u=led_size; $h=led_size; multmatrix(led_corner_transformation_nw(led)) children(); }
module led_corner_ne(led) { $u=led_size; $h=led_size; multmatrix(led_corner_transformation_ne(led)) children(); }
module led_corner_se(led) { $u=led_size; $h=led_size; multmatrix(led_corner_transformation_se(led)) children(); }
module led_corner_sw(led) { $u=led_size; $h=led_size; multmatrix(led_corner_transformation_sw(led)) children(); }
module led_edge_n(led)    { $u=led_size; $h=led_size; multmatrix(led_edge_transformation_n(led)) children(); }
module led_edge_e(led)    { $u=led_size; $h=led_size; multmatrix(led_edge_transformation_e(led)) children(); }
module led_edge_s(led)    { $u=led_size; $h=led_size; multmatrix(led_edge_transformation_s(led)) children(); }
module led_edge_w(led)    { $u=led_size; $h=led_size; multmatrix(led_edge_transformation_w(led)) children(); }

module post_place(index) {
  multmatrix(post_place_transformation(index)) children();
}


module position_back_plate() {
  multmatrix(thumb_place_transformation(1.5, 1))
  translate([0, plate_dimensions.y/2, 0])
  rotate([90, 0, 0])
  translate([0, -20, 0])
    children();
}

module position_back_plate_bottom_left() { position_back_plate() translate([-15, -5, 0]) children(); }
module position_back_plate_bottom_right() { position_back_plate() translate([+15, -5, 0]) children(); }
module position_back_plate_bottom_mid() { position_back_plate() translate([0, -5, 0]) children(); }
module position_back_plate_top_right() { position_back_plate() translate([+15, +15, 0]) children(); }
module position_back_plate_top_left() { position_back_plate() translate([-plate_dimensions.x, +15, 0]) children(); }
module position_back_plate_top_mid() { position_back_plate() translate([0, +15, 0]) children(); }
