# Plate "atoms"

These are the broken down pieces that get hulled and unioned together in various
ways to make up the full plate. With the exception of the test-fitting with the
LED sockets and choc-plate modules there's no reason to render and print any of
these on their own.

## Part descriptions

### `trim.scad`, `trim-profile.scad`

This code is probably the hardest to follow and maintain out of the entire repo.
It involves a lot of deliberate planning and tweaking to account for any changes
to configuration in the `definitions.scad` file. Ideally the trim module would
use the key placement configuration, perhaps with some details about how the
thumb and finger clusters connect, and then generate a perimeter around that.

### `choc-plate.scad`

There isn't much to this one. The keyhole size is configured in `definitions`
but it should probably exist here since it's specific to the Kailh Choc switch
(as are the cutouts for the switch to clip onto).

It considers the `$u`, `$h`, and `$rot` special variables and the
`plate_dimensions` determined in `definitions.scad` for orientation and size.

### `corner.scad`, `edge.scad`

These are small volumed solids that use the configured `plate_thickness` to hull
together and make up an appropriately thick plate. They are deliberately very
thin (the corner's dimensions are `[0.01, 0.01, plate_thickness]`) to avoid
strange artifacts if they happen to be positioned too closely together.

The `plate_edge` works like `plate_corner` but also takes into consideration the
key `$u`, `$h` special variables, and accepts a boolean `horizontal` flag to
determine orientation.

### `led-sockets.scad`

As mentioned in the definitions file, there is a column of LEDs positioned in
part as if it were a scaled down finger column. This module is basically a
trough with holes in bottom for a strip of PCB-mounted LEDs to mount and shine
through from underneath.

This mounting point is recessed so that it can be covered with a diffuser.
