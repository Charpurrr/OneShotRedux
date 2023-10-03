class_name RoomInfo
extends Node2D
# Class for storing room data


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

## This room's ID
@export var id : int = 0

@onready var warps : Node2D = $Warps


func _ready():
	disable_collision()
	for warp in warps.get_children():
		pass

func disable_collision():
	set_visibility_layer_bit(1, false)
	

