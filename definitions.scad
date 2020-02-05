use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

keyswitch_height = 14.4; // Was 14.1, then 14.25
keyswitch_width = 14.4;

keycap_length = 17.6;
keycap_depth = 16.6;
keycap_height = 3.4;

keyhole_length = 13.8;
keywall_thickness = 1.5;

sa_profile_key_height = 12.7;

plate_thickness = 2.7;
plate_vertical_padding = 2.5;
plate_horizontal_padding = 2.5;

plate_width = keyhole_length + plate_horizontal_padding;
plate_height = keyhole_length + plate_vertical_padding;

mount_width = keycap_length + 1;
mount_height = keycap_depth + 1;

cap_top_height = 9;

alpha = 180/12;
beta = 180/36;

finger_row_radius = mount_height / 2 / sin(alpha/2) + cap_top_height;
finger_column_radius = mount_width / 2 / sin(beta/2) + cap_top_height;

thumb_row_radius = mount_height / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = mount_width / 2 / sin(beta/2) + cap_top_height;

finger_column_offset_index = [0, 0, 0];
finger_column_offset_index_stretch = [0, 0, 0];
finger_column_offset_middle = [0, 2.82, -3.0]; // was moved -4.5
finger_column_offset_ring = [0, 0, 0];
finger_column_offset_pinky = [0, -8, 5.64];
finger_column_offset_pinky_stretch = [0, -8, 5.64];
finger_column_offsets = [
  finger_column_offset_index_stretch,
  finger_column_offset_index,
  finger_column_offset_middle,
  finger_column_offset_ring,
  finger_column_offset_pinky,
  finger_column_offset_pinky_stretch
];

finger_columns = [
  [1, 2, 3],
  [1, 2, 3, 4],
  [1, 2, 3, 4],
  [1, 2, 3, 4],
  [1, 2, 3],
  [1, 2, 3]
];

thumb_columns = [
  [-.5],
  [-.5, 1],
  [-1, 0, 1]
];

thumb_overrides = [
  [0, 0, 1, 2, 90],
  [1, 0, 1, 2, 90]
];

desk_arm_thickness = 25;
desk_arm_trunc = 0.8;
desk_arm_radius = (desk_arm_thickness / 2) / desk_arm_trunc;

ball_mount_socket_thickness = 3;
ball_mount_diameter = 28.44;
ball_mount_height = 23.98;
ball_mount_base_orientation = identity4()
  * rotation([0, 0, 90])
  * rotation([60, 0, 0])
  * rotation([0, 0, 180]);

ball_mount_pivot_orientation = identity4()
 * rotation([0, 30, 0]);

desk_thickness = 12.99;
desk_available_depth = 68.98;
desk_top_offset = [0, 50, 40];

function get_overrides (source, colIndex, rowIndex) = (
  let(matches = [
    for(vec=source)
    if (vec[0] == colIndex && vec[1] == rowIndex)
    [ vec[2], vec[3], vec[4] ]
  ])

  len(matches) > 0 ? matches[0] : [1, 1, 0]
);
