class_name Camera
extends Camera2D
## Controling and managing the camera.

@onready var wm : Node2D = owner

var current_room : Node2D


func _ready():
	await(wm.ready)

	current_room = wm.room_coordinator.current_room

	_set_limits()


## Set the camera limits depending on current_room.
func _set_limits():
	current_room = wm.room_coordinator.current_room
