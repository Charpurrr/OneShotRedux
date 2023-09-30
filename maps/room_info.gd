class_name Room
extends Node2D
# Base class for rooms


## Camera limit (left side)
@export_range(0, 10, 1, "or_greater") var lim_l : int
## Camera limit (right side)
@export_range(0, 10, 1, "or_greater") var lim_r : int
## Camera limit (top side)
@export_range(0, 10, 1, "or_greater") var lim_t : int
## Camera limit (bottom side)
@export_range(0, 10, 1, "or_greater") var lim_b : int

## Audio track for this room
@export var audio : AudioStreamPlayer2D
