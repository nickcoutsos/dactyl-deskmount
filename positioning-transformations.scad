use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>
include <definitions.scad>

/**
 * Create a transformation matrix for a finger column and row position.
 *
 * This function turns the column and row into angles for the configured column
 * and row radii, adding column-specific offsets and an overall tilt and offset.
 * This is based on the original dactyl implementation.
 *
 * @param Number column - column position such that 2 is the middle finger home key and increases towards the pinky
 * @param Number row - row position such that 2 is the home row and decreases going toward the number row
 * @return Matrix - the transformation matrix
 */
function finger_transformation(column, row) = (
  let(row_angle = alpha * (2 - row))
  let(column_angle = beta * (2 - column))
  let(column_offset = !is_undef(finger_column_offsets[column])
    ? finger_column_offsets[column]
    : [0, 0, 0])

  translation([0, 0, 13])
  * rotation(beta*3 * Y)
  * translation(column_offset)
  * translation([0, 0, finger_column_radius])
  * rotation(column_angle * Y)
  * translation([0, 0, -finger_column_radius])
  * translation([0, 0, finger_row_radius])
  * rotation(row_angle * X)
  * translation([0, 0, -finger_row_radius])
);

/**
 * Create finger key transformation matrix that includes a pivot for the pinky columns.
 *
 * This passes column and row to `finger_transformation` and creates a pivot
 * point at the pinky finger 4th row (by default there is no key here) to arc
 * the two pinky columns outward slightly.
 *
 * @param Number column
 * @param Number row
 * @return Matrix
 */
function finger_place_transformation(column, row) = (
  let(initial = finger_transformation(column, row))
  let(arc = column >= 4 ? -2 : 0)
  let(pivot = column >= 4
    ? translation_part(finger_transformation(4, 3))
    : [0, 0, 0]
  )

  identity4()
  * translation(pivot)
  * rotation([0, 0, arc])
  * translation(-pivot)
  * initial
);

/**
 * Create thumb key transformation matrix.
 *
 * This works the same way as the finger key transformations. The measurements
 * are taken from the original Dactyl implementation, which I didn't want to
 * experiment too much.
 *
 * @param Number column
 * @param Number row
 * @return Matrix
 */
function thumb_place_transformation (column, row) = (
  let(column_angle = beta * column)
  let(row_angle = alpha * row)

  translation([-52, -45, 40])
  * rotation(axis=alpha * unit([1, 1, 0]))
  * rotation([0, 0, 180 * (.25 - .1875)])
  * translation([mount_width, 0, 0])
  * translation([0, 0, thumb_column_radius])
  * rotation([0, column_angle, 0])
  * translation([0, 0, -thumb_column_radius])
  * translation([0, 0, thumb_row_radius])
  * rotation([row_angle, 0, 0])
  * translation([0, 0, -thumb_row_radius])
);

// These functions extend the basic finger key transformation by shifting to a
// specific corner of that key's plate to simplify joining key plates together.
function finger_corner_transformation_nw(col, row, transform=identity4()) = finger_place_transformation(col, row) * transform * key_size_offset(-1, 1);
function finger_corner_transformation_ne(col, row, transform=identity4()) = finger_place_transformation(col, row) * transform * key_size_offset(1, 1);
function finger_corner_transformation_se(col, row, transform=identity4()) = finger_place_transformation(col, row) * transform * key_size_offset(1, -1);
function finger_corner_transformation_sw(col, row, transform=identity4()) = finger_place_transformation(col, row) * transform * key_size_offset(-1, -1);

function thumb_corner_transformation_nw(colIndex, rowIndex) = let(row=thumb_columns[colIndex][rowIndex]) let(dim=get_overrides(thumb_overrides, colIndex, rowIndex)) thumb_place_transformation(colIndex, row) * key_size_offset(-1, 1, $u=dim[0], $h=dim[1], $rot=dim[2]);
function thumb_corner_transformation_ne(colIndex, rowIndex) = let(row=thumb_columns[colIndex][rowIndex]) let(dim=get_overrides(thumb_overrides, colIndex, rowIndex)) thumb_place_transformation(colIndex, row) * key_size_offset(1, 1, $u=dim[0], $h=dim[1], $rot=dim[2]);
function thumb_corner_transformation_se(colIndex, rowIndex) = let(row=thumb_columns[colIndex][rowIndex]) let(dim=get_overrides(thumb_overrides, colIndex, rowIndex)) thumb_place_transformation(colIndex, row) * key_size_offset(1, -1, $u=dim[0], $h=dim[1], $rot=dim[2]);
function thumb_corner_transformation_sw(colIndex, rowIndex) = let(row=thumb_columns[colIndex][rowIndex]) let(dim=get_overrides(thumb_overrides, colIndex, rowIndex)) thumb_place_transformation(colIndex, row) * key_size_offset(-1, -1, $u=dim[0], $h=dim[1], $rot=dim[2]);

// function thumb_edge_transformation_n(col, row) = let(dim=get_overrides(thumb_overrides, col, row)) thumb_place_transformation(col, row) * key_size_offset(0, 1, $u=dim[0], $h=dim[1], $rot=dim[2]);
// function thumb_edge_transformation_e(col, row) = let(dim=get_overrides(thumb_overrides, col, row)) thumb_place_transformation(col, row) * key_size_offset(1, 0, $u=dim[0], $h=dim[1], $rot=dim[2]);
// function thumb_edge_transformation_s(col, row) = let(dim=get_overrides(thumb_overrides, col, row)) thumb_place_transformation(col, row) * key_size_offset(0, -1, $u=dim[0], $h=dim[1], $rot=dim[2]);
// function thumb_edge_transformation_w(col, row) = let(dim=get_overrides(thumb_overrides, col, row)) thumb_place_transformation(col, row) * key_size_offset(-1, 0, $u=dim[0], $h=dim[1], $rot=dim[2]);

// Similar to `finger_{corner/edge}_transformation_*` but adds the transforms
// used for the LED column.
function led_transformation(led) = finger_place_transformation(leds[led].x, leds[led].y) * led_transform;
function led_corner_transformation_nw(led) = led_transformation(led) * key_size_offset(-1, 1, $uh=led_size);
function led_corner_transformation_ne(led) = led_transformation(led) * key_size_offset( 1, 1, $uh=led_size);
function led_corner_transformation_se(led) = led_transformation(led) * key_size_offset( 1,-1, $uh=led_size);
function led_corner_transformation_sw(led) = led_transformation(led) * key_size_offset(-1,-1, $uh=led_size);
function led_edge_transformation_n(led) = led_transformation(led) * key_size_offset(0, 1, $uh=led_size);
function led_edge_transformation_e(led) = led_transformation(led) * key_size_offset(1, 1, $uh=led_size);
function led_edge_transformation_s(led) = led_transformation(led) * key_size_offset(0, -1, $uh=led_size);
function led_edge_transformation_w(led) = led_transformation(led) * key_size_offset(-1, 0, $uh=led_size);

// Helpers to look for special `$u` or `$h` (or `$uh`) key sizing variables.
function get_u_size() = !is_undef($uh) ? $uh : (!is_undef($u) ? $u : 1);
function get_h_size() = !is_undef($uh) ? $uh : (!is_undef($h) ? $h : 1);
function key_size_offset(x, y) = translation([
  plate_dimensions.x * get_u_size() * x / 2,
  plate_dimensions.y * get_h_size() * y / 2,
  0
]);


// Transformation matrices for each screw post.
r_offset = [0, plate_dimensions.y/2 + plate_thickness * cos(360/12), 0];
posts = [
  thumb_place_transformation(2.5, 0.5) * translation([-2.2, 0, -5]) * rotation([0, -20, 0]) * rotation([0, 0, -90]),
  finger_place_transformation(1, 4) * translation(-r_offset) * translation([2, 0, -plate_thickness + plate_thickness * sin(360/12)]) * rotation([35, 0, 0]) * translation([0, -4, -3]),
  finger_place_transformation(1, 1) * translation(r_offset) * translation([2, 0, -plate_thickness + plate_thickness * sin(360/12)]) * rotation([-33, 0, 0]) * rotation([0, 0, 180]) * translation([0, -4, -3]),

  finger_place_transformation(4, 3) * translation(-r_offset) * translation([0, 0, -plate_thickness + plate_thickness * sin(360/12)]) * rotation([33, 0, 0]) * translation([0, -4, -3]),
  finger_place_transformation(4, 1) * translation(r_offset) * translation([0, 0, -plate_thickness + plate_thickness * sin(360/12)]) * rotation([-33, 0, 0]) * rotation([0, 0, 180]) * translation([0, -4, -3])
];

function post_place_transformation (index) = (
  posts[index]
);
