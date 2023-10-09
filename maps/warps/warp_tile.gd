class_name WarpTile
extends TileMap
# Tile that warps you to a new location or scene


## What area to warp to
@export var destination_area : String
## What room to warp to
@export var destination_room : String

## Coordinations of entry point
@export var enter_origin : Vector2
## Coordinations of exit point
@export var exit_origin : Vector2

@onready var wm : Node2D = $/root/WorldMachine
@onready var niko : CharacterBody2D = wm.niko


func _physics_process(_delta):
	if wm.transition.is_transitioning: return

	var niko_pos : Vector2 = niko.position
	var pos : Vector2i = floor(niko_pos / 16)

	var tile_data : TileData = get_cell_tile_data(0, pos)

	if tile_data == null: return

	var warp_enter : Vector2 = tile_data.get_custom_data("warp_enter")
	var warp_exit : Vector2 = tile_data.get_custom_data("warp_exit")
	var enter_type : StringName = tile_data.get_custom_data("enter_type")

	var should_activate : bool = false

	match enter_type:
		"input_based":
			if Input.get_vector("left", "right", "up", "down") == warp_enter:
				should_activate = niko.is_on_wall()
		"enter_based":
			should_activate = true

	if should_activate == true:
		var destination_pos : Vector2 = niko_pos - enter_origin + exit_origin

		wm.room_coordinator.upd_current_room(destination_area, destination_room, destination_pos)
