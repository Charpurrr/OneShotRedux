class_name PauseMenu
extends CanvasLayer
## Class for the pause menu.


func _input(event):
	if event == &"pause":
		queue_free()
