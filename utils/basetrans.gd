extends Node2D

@export_file var goes_to : String
@onready var area2d = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	area2d.connect("body_entered", entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func entered(body):
	get_tree().change_scene_to_file(goes_to)
