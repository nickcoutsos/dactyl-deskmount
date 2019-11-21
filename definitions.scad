X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

keyswitch_height = 14.4; // Was 14.1, then 14.25
keyswitch_width = 14.4;

keycap_length = 17.5;
keycap_inner_length = 12.37;
keycap_height = 3.4;

keyhole_length = 14;
keywall_thickness = 1.5;

sa_profile_key_height = 12.7;

plate_thickness = 1.5;
plate_vertical_padding = 2;
plate_horizontal_padding = 2;

plate_width = keyhole_length + 2 * plate_horizontal_padding;
plate_height = keyhole_length + 2 * plate_vertical_padding;

mount_width = keyswitch_width + 3;
mount_height = keyswitch_height + 3;

cap_top_height = 9;

alpha = 180/24;
beta = 180/36;

finger_row_radius = (mount_height + 0.25) / 2 / sin(alpha/2) + cap_top_height;
finger_column_radius = (mount_width + 0.25) / 2 / sin(beta/2) + cap_top_height;

thumb_row_radius = (mount_height + 0.25) / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = (mount_width + 0.25) / 2 / sin(beta/2) + cap_top_height;

finger_column_offset_index = [0, 0, 0];
finger_column_offset_index_stretch = [0, 0, 0];
finger_column_offset_middle = [0, 2.82, -3.0]; // was moved -4.5
finger_column_offset_ring = [0, 0, 0];
finger_column_offset_pinky = [0, -5.8, 5.64];
finger_column_offset_pinky_stretch = [0.5, -5.8, 5.64];
finger_column_offsets = [
  finger_column_offset_index_stretch,
  finger_column_offset_index,
  finger_column_offset_middle,
  finger_column_offset_ring,
  finger_column_offset_pinky,
  finger_column_offset_pinky_stretch
];

finger_columns = [
  [0, 1, 2, 3],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4],
  [0, 1, 2, 3, 4]
];

thumb_columns = [
  [-.5],
  [-.5, 1],
  [-1, 0, 1]
];
