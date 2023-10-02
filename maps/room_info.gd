class_name Room
extends Node2D
# Base class for rooms

@export var transitions : Node
@export var niko : Node

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

@export var id : int = 0

func _ready():
	RoomCoordinator.current_room = self
	for i in transitions.get_children():
		if i.destination == RoomCoordinator.current_room_id && RoomCoordinator.next_room_id == id:
			niko.position = i.position
	RoomCoordinator.current_room_id = id
	niko.camera.set_limits()
	
