# dactyl-deskmount
---
![dactyl-deskmount.jpg](outputs/dactyl-deskmount.jpg "Dactyl and desk mounting hardware")

## Goal

Essentially, make a variant of the [dactyl-keyboard] that doesn't impose
significant extra height above my desk surface.

I previously designed and built the "[dactyl-flatpacked]", a Dactyl made from
slotted acrylic pieces instead of 3D printed, and ended up loving the keyboard.
Like most non-planar keyboards it has an issue with overall height. The lowest
row requires my wrist/palm needs to clear around 4cm, and unfortunate
combinations of desk-chair-user height can exacerbate things. Ultimately it has
taught me to properly float my wrists while typing, but I still wanted to see
what else could be done.

Another goal I had was to have a pure and simple OpenSCAD version of the dactyl
that wouldn't require the complexity of compiling and executing Clojure to
generate unreadable OpenSCAD code. This part started out pretty well but over
time I got tired of limitations around code organization and stopped trying so
hard to keep features modular while still having something aesthetically
pleasing.

I still stand by working directly in OpenSCAD, but if I were to start
over or dedicate significant time to refactoring I would look into more of the
community OpenSCAD libraries for things like generating hulls from profiles
instead of mimicking triangle hulls and such that I saw in the origin dactyl
code.


## Inspiration

Through the mechanical keyboard subreddit I came across a couple of keyboard
mounting designs that helped me see the possibility of using ball-and-socket
mounts.

**ElliotCable: [Ergovox]**

This ergodox keyboard uses RAM mounts screwed into the bottom of a standing desk
allowing for a fully vertical (or any angle, really) keyboard orientation.

**Martin Körner: [Georgi stand with trackball]**

This georgi uses ball camera mounts attached to a tripod, removing the desktop
from the equation altogether. With the tripod you can precisely control height
and the trackball mount is a nice bonus as well.


## Design Considerations

**Desk mounted via clamps**

The tripod stand is cool but I work at a desk. Unfortunately when I'm in the
office it isn't my desk so stability is sacrificed to avoid drilling holes.


**Camera ball mounts**

I don't want to go to all the trouble of building a keyboard only to wonder if a
steeper tenting angle would be better. I also get to control the pitch and yaw
if I like. I had a lot of misgivings about this. Ideally it would be positioned
so that the majority of the the force put into the keyboard goes straight
through the ball to avoid torque causing the ball to slip.

Unfortunately putting the ball mount directly underneath my hand would take up
room underneath the keyboard and cause problems for the sitting position. I made
the concession of offsetting the mount a little with the hope that by the time I
begin to see obvious slippage I will have found an angle I like and print static
arms to clamp onto my desk. Worst case scenario, I can print a more traditional
base and use the keyboard on my desktop like an animal.

**Keycaps and layout**

I use choc low-profile switches because I had them leftover from an earlier
iteration I didn't end up liking. I designed and printed custom variations of
the 2u keycaps (because, quite simply, I like the Dactyl's thumb cluster) and
deep-dished homing keycaps.

The same positioning algorithm from the original Dactyl is used but with a
slight outward pivot of the pinky columns, and removed keys:

* no number row because I hate it
* pinky keys removed from row 4

Were I a braver person I would remove even more keys (the entire pinky columns)
and learn to love QMK combos but I never properly made sense of the config
options like `PERMISSIVE_HOLD` and `IGNORE_MOD_TAP_INTERRUPT` which made for a
bad experience in the past.

**LEDs**

I want to have visual indicators for things like Caps Lock (because I find caps
lock useful) and potentially notifications pushed from the host via Raw HID.
Admittedly I do think a few subtle lights can add to the keyboard's aesthetics.


## Mounting hardware

* 3d printed desk clamps
  * I include a cutout for 1/4"x5/16" tee-nut.
  * a 1/4"-20 x 1 1/4" hex bolt (with 3d printed knob and swivel plate) are used
    for tightening.
* 1/4" ball mount (I used a [ball mount tripod adapter] from AliExpress)
  * This attaches to my 3d printed clamp via a couple of m4 screws
* 3d printed keyboard bottom mount attached to the top of the ball mount via
  another tee-nut.
    * at the beginning I set out to use heat-set inserts like I've seen on many
      other projects but couldn't find a source for the right kind in a useful
      quantity.
    * I'm finding tee-nuts to be incredibly useful in 3d printed projects when I
      want to securely fasten things to a single screw.
* 3d printed keyboard plate attaches to 3d printed mount via m3 screws.
  * the design uses three m3 mounting holes on the keyboard plate matching up
    with three holes on the mount (one on the far edge of the thumb cluster and
    two at the top and bottom of the index finger column).
  * there are two more unused screw holes on the pinky finger column in case I
    want to re-design a more robust bottom mount.
* another 3d printed mount hanging underneath the thumb cluster holds a 24-pin
  wide IC socket for the pro micro controller. Ribbon cables conned the socket
  pins to the keyboard matrix and TRRS socket. A stripped micro USB connector
  connects from a sturdier micro USB socket breakout board to the pro micro.


## Pre-rendered parts

_TODO: commit STL files_


[dactyl-keyboard]:https://github.com/adereth/dactyl-keyboard/
[dactyl-flatpacked]:https://github.com/nickcoutsos/dactyl-flatpacked/
[Georgi stand with trackball]:https://stenoblog.com/georgi-stand-with-trackball/
[Ergovox]:https://www.reddit.com/r/MechanicalKeyboards/comments/8ib8pi/something_a_little_different_the_ergovox/
[ball mount tripod adapter]:https://www.aliexpress.com/item/4000183944867.html
