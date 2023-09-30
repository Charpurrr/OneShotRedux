class_name Niko
extends CharacterBody2D
# Movement class for Niko


@onready var camera : Camera2D = $Camera2D

const PAUSE_MENU : PackedScene = preload("res://ui/pause_screen/pause_screen.tscn")

var speed = 100


func _physics_process(_delta):
	pause()
	movement()
	move_and_slide()


## Handles movement
func movement():
	var input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_vector * speed


## Open the pause menu
func pause():
	if Input.is_action_just_pressed("Pause"):
		add_child(PAUSE_MENU.instantiate())
