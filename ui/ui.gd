class_name UserInterface
extends CanvasLayer
## General UI class.


@onready var niko: CharacterBody2D = %Niko

const PAUSE_MENU: PackedScene = preload("res://ui/pause_menu/pause_menu.tscn")

var paused: bool = false


func _process(_delta):
	_pausing()


## Handles pausing and unpausing the game.
func _pausing():
	if niko.in_dialogue: return

	var pause_scene: PauseMenu = PAUSE_MENU.instantiate()

	# Pause
	if Input.is_action_just_pressed(&"pause") and not paused:
		add_child(pause_scene)

		niko.can_move = true
		paused = true
	# Unpause
	elif (Input.is_action_just_pressed(&"pause") or Input.is_action_just_pressed(&"cancel")):
		pause_scene.queue_free()

		niko.can_move = false
		paused = false
