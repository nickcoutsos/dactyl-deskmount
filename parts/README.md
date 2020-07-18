# Parts

OpenSCAD files in this directory are individually printable pieces used to
assemble the keyboard.

Files under `placeholders/` are approximations of existing parts (screws, PCBs,
etc.) that shouldn't be printed, but are used to help provide a clearer picture
of the assembly and/or for subtraction. These modules will often have optional
parameters like `$clearance` and `footprint` to help create appropriately sized
negative spaces in the printed pieces.

## Printable Parts

### `plate.scad`

This is the main component. It connects a number of plates arranged according to
the defined row and column sizes and curvatures. It also includes a trim made of
a quarter-round profiled edge, a space for a column of 3535 PCB LEDs and a few
m3-sized screw holes to attach to the keyboard's bottom-mount.

### `socket-mount.scad`

The socket mount gives me a place to attach my pro micro socket hanging below
the thumb cluster. When I assembled everything I ended up cutting out most of
the horizontal pieces so that I could solder directly to the socket before
gluing things down.

In retrospect, this could have been simplified and printed as part of the plate
itself but I was worried about how well it would come out given that it would be
printing on top of support material.

### `led-diffuser.scad`

I had few versions of this, but the idea is to print a very thin (1 line thick)
cover in transparent or light coloured filament to diffuse the LED light. It
worked ok. The important thing was to not blind anybody catching an eyeful of my
keyboard's lights, but printing it in translucent filament gives a very pretty
look. If you render the script standalone (instead of importing the module) its
in a standing position with manually generated support for printing stability.

In the end I settled on a solid pyramid-like pattern hoping to get interesting
refraction of the light, but if I were to do this again I would redesign the
plate so that this part doesn't have curves on multiple axis and cut a piece of
acrylic for the LEDs to shine through the edge.

### `bottom-mount.scad`

This may be the lightest piece that takes most of the strain. It attaches to the
ball mount (secured in place via a tee-nut) with arms extending to screw holes
on the plate that fasten via m3 screw and hex nut.

__**NEW:**__ after a bit of use I was happy with the stability fo the camera
mount, but the plate itself would flex a fair bit when pressing keys on outer
columns (particularly modifiers like shift and layer toggles where I'm holding
the key down). The bottom mount has been updated to add additional branches to
connect to the outer column screw holes, and all arms have been made thicker.

Now the main source of flex comes from the table hook.

### `table-hook.scad`

The table hook (which includes the `clamp.scad` part) is a holder for the ball
mount, a short arm, and a clamp that attaches to the edge of the desk. I have
a separate file for the clamp that that I could print and test it separately but
for consistency it should be moved and the table-hook file should include a
module that cuts it down to the testable printable section.

This piece can be printed without supports if you're ok a not-so-nice bottom
side (and that your printer is good enough but I guess that goes for everything)

### `choc.scad`

Most of my keyboard uses regular Kailh Choc 1u keycaps, but I made a custom
version to print my own 2u and scooped 1u (with bump) versions.

This is not the same as `placeholders/keycap.scad` which doesn't include the
stem or cavity (or surface detail).


## Plate "atoms"

Modules in this directory are the "atoms" that make up the full plate. On their
own they are useless but the intention is to hull the pieces together.


## Placeholders

![placeholders.png](outputs/placeholders.png "Placeholder parts")

_(left to right: `led`, `hex_nut`, `hex_bolt`, `socket`, `kailh_choc_keycap`,
`kailh_choc_switch`, `m3_nut`, `m3_screw`, `micro_usb_breakout`, `pro_micro`,
`tee_nut`, `trrs_breakout`)_

_(top to bottom: normal, `$detail=true`, `$detail=true; $clearance=1`)_

### `3535-led.scad`

Everything I do is handwired so surface mount components aren't really an option.
You can find ws2812b LEDs on individual PCBs (including capacitor and resistor)
which makes things a little easier, so I use them happily. This placeholder
accounts for the placement of the capacitor and resistor so that it can be
subtracted from the plate, leaving a helpful socket.

When soldering the chain of LEDs together I found it helpful to take a length
of wire, strip of the insulation, twist the strands together, and solder that
across each line of pads (VCC, DIn/DOut\*, GND) instead of cutting individual
wires and soldering them one at a time. 

\*Although VCC and GND on the LEDs are technically parallel, the signal line
is serial so if you do this you absolutely need to cut the wires to so that the
DI and DO pads of the same PCB are NOT connected.

### `ball-mount.scad`

This module gives me a visual of the ball mount part with a couple of extras:

1. I can render child modules that are "attached" to the mount
2. I can pass in transformations that it will apply to the base and mount to
   let me pivot things.
3. It will pass the inverse of those pivots to the child modules so that I can
   undo transformations as needed.

### `ic-socket.scad`

A 24 pin wide IC socket.

### `keycap.scad`

Rough approximation of a kailh choc keycap. It looks for OpenSCAD special
variables (`$u`, `$h`, and `$rot`) that may be set by the positioning module to
give us per-key customizations. The override definitions for the thumb cluster
makes use of this to implement the tall "vertical" keycaps as rotated "wide"
keycaps.

It can also look for `$key_pressed` to translate the keycap downward so you can
visualize the space between keys when pressed vs unpressed.

### `keyswitch.scad`

Rough approximation of a kailh choc keyswitch. This visual is helpful to plan
out where the switch pins will end up in the final layout, although I think I
might be the only person in the world not rotating them 180 degrees so that the
pins face "North".

### `m3-hex-nut.scad`, `m3-screw.scad`

As advertised, more or less.

### `micro-usb-breakout.scad`, `trrs-breakout.scad`

These are only going to be so useful. I wanted a Micro USB socket (and breakout
board because I can't solder those tiny contacts) so I don't have to worry about
breaking the Pro Micro's connector but this is only useful if you use a breakout
with the same dimensions. Same goes for the TRRS breakout except even less ideal
because the breakout boards I sourced are bigger than this but I cut them down
to save space and keep symmetry.

### `promicro.scad`

This is based on a black Pro Micro from AliExpress.

### `table.scad`

Just a rectangle. I made the corners round to be fancy.

### `tee-nut.scad`

This is a 1/4"-20 (coarse thread) 5/16" tall tee nut I found in a nearby
hardware store. I'd like to think that any differences between what I used and
what you have available can be solved with adjusted `$clearance` values or a
little bending and cutting.

