class_name RoomCoordinator
extends Node2D
## Handles loading and transitioning between rooms and areas.


@onready var wm : Node2D = owner

@onready var niko : CharacterBody2D = %Niko
@onready var camera : Camera2D = %Camera

var current_room : Node2D = null
var destination : int = 0


## Update room by utilising transitions.
func _transition_upd(new_room : Node2D, previous_room : Node2D, 
destination_pos : Vector2, exit_facing : Vector2
):
	niko.set_collision_mask_value(1, false)
	niko.can_move = false

	await wm.transition.fade_out(previous_room)

	call_deferred("add_child", new_room)
	niko.reparent(new_room)

	niko.upd_facing_direction(exit_facing)
	niko.position = destination_pos + (niko.collision.shape.size.x) * 0.5 * exit_facing

	await wm.transition.fade_in(new_room)

	niko.set_collision_mask_value(1, true)
	niko.can_move = true


## Update room by utilising its spawn point.
func _sudden_upd(new_room : Node2D):
	call_deferred("add_child", new_room)

	await new_room.ready

	var room_sp : Sprite2D = new_room.sp_hologram

	niko.upd_facing_direction(room_sp.spawn_facing)
	niko.position = room_sp.position

	niko.reparent(new_room)


## Transitions and updates to a new room.
func upd_current_room(
	new_area : StringName, new_room : StringName, 
	exit_facing : Vector2, destination_pos := Vector2.ZERO
):
	var instantiated_room : Node2D = wm.areas[new_area].rooms[new_room].instantiate()
	var previous_room : Node2D = current_room

	current_room = instantiated_room

	if previous_room != null:
		_transition_upd(instantiated_room, previous_room, destination_pos, exit_facing)
	else:
		_sudden_upd(instantiated_room)
