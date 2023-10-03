class_name Warp
extends Node2D
# Action/interaction that warps you to a new location or scene


### Type of warp
@export var dest_area : String

@export var destination : String

@export var ID : int

@export var dest_ID : int

@onready var wm : Node2D = $/root/WorldMachine

@onready var area = $Area2D

var entered_warp : bool # Check if Niko entered a warp

var prev_room : int # ID of the room Niko was previously in


func _ready():
	area.connect("body_entered", entered)
#	area.connect("body_exited", exited)


	area.monitoring = false
	await(get_tree().create_timer(1)).timeout
	area.monitoring = true


func entered(body):
	if "Niko" in str(body):
		wm.room_coordinator.upd_current_room(dest_area, destination)


