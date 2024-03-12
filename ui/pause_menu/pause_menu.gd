class_name PauseMenu
extends CanvasLayer
## Class for the pause menu.


@onready var ui: UserInterface = get_parent()


func _ready():
	ui.niko.can_move = false


func _input(_event):
	if Input.is_action_just_pressed(&"cancel"):
		ui.niko.can_move = true
		ui.paused = false

		queue_free()
