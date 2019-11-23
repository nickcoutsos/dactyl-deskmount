use <scad-utils/transformations.scad>
use <scad-utils/linalg.scad>
include <definitions.scad>


module finger_place(column, row) {
  transformation = finger_place_transformation(column, row);
  multmatrix(transformation)
    children();
}

function finger_place_transformation(column, row) = (
  let(row_angle = alpha * (2 - row))
  let(column_angle = beta * (2 - column))
  let(column_offset = finger_column_offsets[column])

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

module thumb_place (colIndex, rowIndex) {
  dimensions = get_overrides(thumb_overrides, colIndex, rowIndex);
  $u = dimensions[0];
  $h = dimensions[1];
  rot = dimensions[2];
  column = colIndex;
  row = thumb_columns[colIndex][rowIndex];

  multmatrix(thumb_place_transformation(column, row))
    rotate([0, 0, rot])
    children();
}

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

module place_thumb_keys (columns, rows) {
  for (col=columns, row=rows) {
    if (col != 0 || row != 4) {
      thumb_place(col, row) children();
    }
  }
}
