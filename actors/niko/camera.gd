class_name Camera
extends Camera2D
# Controling and managing the camera

@onready var wm : Node2D = owner

var current_room : Node2D


func _ready():
	await(wm.ready)

	current_room = wm.room_coordinator.current_room

	set_limits()


## Set the camera limits depending on current_room
func set_limits():
	limit_bottom = current_room.lim_b
	limit_right = current_room.lim_r
	limit_left = current_room.lim_l
	limit_top = current_room.lim_t
