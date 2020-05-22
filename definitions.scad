use <scad-utils/linalg.scad>
use <scad-utils/transformations.scad>

X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

// these measurements are specific to kailh choc caps and switches.
keyhole_length = 13.8;
keycap_length = 17.6;
keycap_depth = 16.6;
keycap_height = 3.4;
cap_top_height = 9;

plate_thickness = 2.7;
plate_padding = [2.5, 2.5]; // horizontal and vertical padding around switches.
plate_dimensions = [
  keyhole_length + plate_padding.x,
  keyhole_length + plate_padding.y,
  plate_thickness
];

// overall space allotted for each keycap
mount_width = keycap_length + 1;
mount_height = keycap_depth + 1;

// angle from key-to-key in a column (alpha) and column-to-column (beta)
alpha = 180/12;
beta = 180/36;

finger_row_radius = mount_height / 2 / sin(alpha/2) + cap_top_height;
finger_column_radius = mount_width / 2 / sin(beta/2) + cap_top_height;
thumb_row_radius = mount_height / 2 / sin(alpha/2) + cap_top_height;
thumb_column_radius = mount_width / 2 / sin(beta/2) + cap_top_height;

// Per-column offsets for finger keys.
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

// Per-column selection of keys an their row positions.
// Values here don't need to be integers but they probably should be.
finger_columns = [
  [1, 2, 3],
  [1, 2, 3, 4],
  [1, 2, 3, 4],
  [1, 2, 3, 4],
  [1, 2, 3],
  [1, 2, 3]
];

// Per-column selection of thumb keys and their row positions.
// In this case because of the 2u keys there's need to use fractional values.
thumb_columns = [
  [-.5],
  [-.5, 1],
  [-1, 0, 1]
];

// Thumb overrides specify on a per-colum-index-and-row-index basis:
// * size multiplier (u and h)
// * rotation (in degrees)
// Note: this is only used for thumb keys and doesn't support the ergodox-style
// 1.25u outer pinky-column keys.
thumb_overrides = [
  [0, 0, 1, 2, 90],
  [1, 0, 1, 2, 90]
];

// how thick to make the arm/clamp.
// I haven't tried other values as I didn't want to print one that's too weak
// and keep iterating. Wouldn't be a bad idea to render one and throw it into
// Fusion360 or something for finite element analysis, but I'm not an engineer.
desk_arm_thickness = 25;
desk_arm_trunc = 0.8;
desk_arm_radius = (desk_arm_thickness / 2) / desk_arm_trunc;

// These measurements are specific to the ball mount I bought.
ball_mount_diameter = 28.44;
ball_mount_height = 23.98;

// How thick to make the walls of the cylinder that the ball mount slides into.
// The desk arm actually screws into the ball mount base so this probably isn't
// adding to print strength at all.
ball_mount_socket_thickness = 3;

// What orientation should the ball mount have in the desk arm's socket.
// Tilting this gives you more clearance from the desk arm, but pay attention to
// your print orientation to ensure torque applied to the ball mount doesn't act
// on layer weakness.
ball_mount_base_orientation = identity4()
  * rotation([0, 0, 90])
  * rotation([50, 0, 0])
  * rotation([0, 0, 180]);

// What orientation to apply to things attached to the ball mount head.
// This doesn't affect printed parts directly but is useful for visualization.
ball_mount_pivot_orientation = identity4()
 * rotation([0, 30, 0]);

// The precise thickness isn't important if you want to secure the arm with a
// clamp (1/4" bolt). In fact, my preference is to leave a few millimetres of
// clearance so that you can augment your printed parts with grippier material:
// silicone/rubber sheet or even kitchen drawer liners can be used as a softer
// layer to avoid damaging the desk surface.
_DESK_THICKNESS_TURNSTONE_BIVI = 14.99; // my work desk
_DESK_THICKNESS_IKEA_SKARSTA = 22.28;   // my home desk
desk_thickness = _DESK_THICKNESS_IKEA_SKARSTA;
desk_available_depth = 68.98;

// Desired offset from ball mount base to the top (ignoring thickness) of desk.
desk_top_offset = [0, 50, 40];

// Desired offset from keyboard "origin" to bottom mount component.
keyboard_offset = rotation([0, -20, 0]) * translation([30, 5, -6]);

// Look up thumb overrides for given column and row index
function get_overrides (source, colIndex, rowIndex) = (
  let(matches = [
    for(vec=source)
    if (vec[0] == colIndex && vec[1] == rowIndex)
    [ vec[2], vec[3], vec[4] ]
  ])

  len(matches) > 0 ? matches[0] : [1, 1, 0]
);
