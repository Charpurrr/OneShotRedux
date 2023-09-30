class_name PauseMenu
extends CanvasLayer
# Class for the pause menu


func _init():
	get_tree().paused = true


func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = false
		queue_free()
