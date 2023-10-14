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


func _ready():
	modulate.a = 0


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
			if check_input_based_satisfied(warp_enter):
				should_activate = niko.is_on_wall()
		"enter_based":
			should_activate = true

	if should_activate == true:
		var offset : Vector2 = niko_pos - enter_origin
		var perp_offset : Vector2 = offset * warp_enter.orthogonal().abs()
		var destination_pos : Vector2 = perp_offset + exit_origin

		wm.room_coordinator.upd_current_room(destination_area, destination_room, warp_exit, destination_pos)


func check_input_based_satisfied(enter_vector : Vector2) -> bool:
	return (sign(Input.get_vector("left", "right", "up", "down").dot(enter_vector)) == 1 
	and check_wall_colliding(enter_vector))


func check_wall_colliding(enter_vector : Vector2) -> bool:
	for i in niko.get_slide_collision_count():
		if niko.get_slide_collision(i).get_normal().is_equal_approx(-enter_vector):
			return true

	return false
