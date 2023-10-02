class_name Warp
extends Node2D
# Action/interaction that warps you to a new location or scene


### Type of warp
#@export_enum("Fade", "Instant", "Eyes") var type : String
### The ID of the room you warp to
#@export var destination : int
#
#@onready var area = $Area2D
#
#var entered_warp : bool # Check if Niko entered a warp
#
#var prev_room : int # ID of the room Niko was previously in
#
#
#func _ready():
#	area.connect("body_entered", entered)
#	area.connect("body_exited", exited)
#
#	prev_room = RoomCoordinator.current_room_id
#
#	area.monitoring = false
#	await(get_tree().create_timer(1)).timeout
#	area.monitoring = true
#
#
#func entered(body):
#	if "Niko" in str(body):
#		if body.warped == false:
#			RoomCoordinator.next_room_id = destination
#			get_tree().change_scene_to_file(RoomIDs.ID[destination])
#			body.warped = true
#			entered_warp = true
#
#
#func exited(body):
#	if entered_warp != true:
#		if "Niko" in str(body):
#			body.warped = false
