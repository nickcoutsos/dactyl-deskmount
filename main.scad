use <placeholders.scad>
use <positioning.scad>
include <definitions.scad>

for (col=[0:len(finger_columns)-1]) {
  for (row=finger_columns[col]) {
    finger_place(col, row) kailh_choc_switch();
    finger_place(col, row) color("lightsteelblue") kailh_choc_plate();
    finger_place(col, row) color("white") kailh_choc_keycap();
  }
}

for (colIndex=[0:len(thumb_columns)-1]) {
  for (rowIndex=[0:len(thumb_columns[colIndex])-1]) {
    thumb_place(colIndex, rowIndex) kailh_choc_switch();
    thumb_place(colIndex, rowIndex) color("lightsteelblue") kailh_choc_plate();
    thumb_place(colIndex, rowIndex) color("white") kailh_choc_keycap();
  }
}
