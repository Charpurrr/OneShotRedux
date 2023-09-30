class_name PauseMenu
extends CanvasLayer
# Class for the pause menu


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		queue_free()
