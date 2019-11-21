use <positioning.scad>
include <definitions.scad>


for (col=[0:len(finger_columns)-1]) {
  for (row=finger_columns[col]) {
    finger_place(col, row) cube([keyswitch_width, keyswitch_height, 2], center=true);
  }
}

for (col=[0:len(thumb_columns)-1]) {
  for (row=thumb_columns[col]) {
    thumb_place(col, row) cube([keyswitch_width, keyswitch_height, 2], center=true);
  }
}
