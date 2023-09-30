class_name Warp
extends Node2D
# Area region that warps you to a new location or scene


@export_file var destination : String

@onready var area = $Area2D


func _ready():
	pass
#	area.connect("body_entered", entered)


#func entered(_body):
#	get_tree().change_scene_to_file(destination)
