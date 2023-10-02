class_name RoomCoordinator
extends Node2D
# Handles loading and transitioning between rooms and areas

@onready var wm : Node2D = owner

var current_room : Node2D = null


## Transitions and updates to a new room
func upd_current_room(new_area : StringName, new_room : StringName):
	var instantiated_room : Node2D = wm.areas[new_area].rooms[new_room].instantiate()

	if current_room != null:
		current_room.queue_free()

	add_child(instantiated_room)

	current_room = instantiated_room
