include <../../definitions.scad>
use <../placeholders/choc-plate.scad>
use <../placeholders/mx-plate.scad>

module switch_plate() {
  if (switch_type == "choc") kailh_choc_plate();
  if (switch_type == "mx") mx_plate();
}
