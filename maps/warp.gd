class_name Warp
extends Node2D
# Area region that warps you to a new location or scene

var entered_warp
var prev_room
@export var destination : int
@export_enum("Subarea", "Main") var type : String

@onready var area = $Area2D


func _ready():
	prev_room = RoomCoordinator.current_room_id
	area.connect("body_entered", entered)
	area.connect("body_exited", exited)
	area.monitoring = false
	await(get_tree().create_timer(1)).timeout
	area.monitoring = true

func entered(body):
	if "Niko" in str(body):
		if body.warped == false:
			RoomCoordinator.next_room_id = destination
			get_tree().change_scene_to_file(RoomIDs.ID[destination])
			body.warped = true
			entered_warp = true
			
func exited(body):
	if entered_warp != true:
		if "Niko" in str(body):
			body.warped = false
