use <placeholders.scad>
use <positioning.scad>
include <definitions.scad>

module thumb_key(colIndex, rowIndex) {
  column = thumb_columns[colIndex];
  col = colIndex;
  row = column[rowIndex];
  dimensions = get_overrides(thumb_overrides, colIndex, rowIndex);
  $u = dimensions[0];
  $h = dimensions[1];
  rot = dimensions[2];

  thumb_place(col, row)
  rotate([0, 0, rot])
    children();
}

for (col=[0:len(finger_columns)-1]) {
  for (row=finger_columns[col]) {
    finger_place(col, row) kailh_choc_switch();
    finger_place(col, row) color("lightsteelblue") kailh_choc_plate();
    finger_place(col, row) color("white") kailh_choc_keycap();
  }
}

for (colIndex=[0:len(thumb_columns)-1]) {
  for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
    thumb_key(colIndex, rowIndex) kailh_choc_switch();
    thumb_key(colIndex, rowIndex) color("lightsteelblue") kailh_choc_plate();
    thumb_key(colIndex, rowIndex) color("white") kailh_choc_keycap();
  }
}
