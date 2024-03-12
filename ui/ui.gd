class_name UserInterface
extends CanvasLayer
## General UI class.


@onready var niko: CharacterBody2D = %Niko

const PAUSE_MENU: PackedScene = preload("res://ui/pause_menu/pause_menu.tscn")

var paused: bool = false


func _process(_delta):
	_pausing()


## Handles pausing the game alongside opening its menu.
func _pausing():
	if Input.is_action_just_pressed(&"pause") and not paused and not niko.in_dialogue:
		add_child(PAUSE_MENU.instantiate())

		paused = true
