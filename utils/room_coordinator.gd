class_name RoomCoordinator
extends Node2D
# Handles loading and transitioning between rooms and areas


@onready var wm : Node2D = owner

@onready var niko : CharacterBody2D = %Niko
@onready var camera : Camera2D = %Camera

var current_room : Node2D = null
var destination : int = 0


## Transitions and updates to a new room
func upd_current_room(new_area : StringName, new_room : StringName, destination_pos : Vector2):
	var instantiated_room : Node2D = wm.areas[new_area].rooms[new_room].instantiate()
	var previous_room : Node2D = current_room

	current_room = instantiated_room

	if previous_room != null:
		niko.set_collision_mask_value(1, false)
		niko.can_move = false

		await wm.transition.fade_out(previous_room)

		call_deferred("add_child", instantiated_room)
		niko.reparent(instantiated_room)
		niko.position = destination_pos

		await wm.transition.fade_in(instantiated_room)

		niko.set_collision_mask_value(1, true)
		niko.can_move = true
	else:
		call_deferred("add_child", instantiated_room)

		await instantiated_room.ready

		niko.position = instantiated_room.room_spawn_point
		niko.reparent(instantiated_room)
