class_name RoomCoordinator
extends Node2D
# Handles loading and transitioning between rooms and areas

@onready var wm : Node2D = owner

@onready var camera : Node2D = owner.get_node("Niko").get_node("Camera")

var current_room : Node2D = null


## Transitions and updates to a new room
func upd_current_room(new_area : StringName, new_room : StringName):
	var instantiated_room : Node2D = wm.areas[new_area].rooms[new_room].instantiate()
	var prev_room = current_room
	add_child(instantiated_room)
	current_room = instantiated_room
	print(current_room)
	
	if prev_room != null:
		instantiated_room.z_index = prev_room.z_index - 3
		var tween = create_tween()
		tween.tween_property(prev_room, "modulate:a", 0, 0.5)
		await tween.finished
		prev_room.queue_free()
		camera.set_limits()
		instantiated_room.z_index = instantiated_room.z_index + 3
		

func fade_in(previous_room):
	var tween = create_tween()
	tween.tween_property(previous_room, "modulate:a", 0, 0.5)
	await tween.finished
