class_name Niko
extends CharacterBody2D
# Movement class for Niko


@onready var doll : AnimatedSprite2D = $Doll
@onready var camera : Camera2D = $Camera2D

@onready var occluder_h : LightOccluder2D = $LightOccluderHorizontal
@onready var occluder_v : LightOccluder2D = $LightOccluderVertical

const PAUSE_MENU : PackedScene = preload("res://ui/pause_screen/pause_screen.tscn")

const RUN_SPEED : int = 100
const SPEED : int = 50

var facing_direction : StringName = "bottom"


func _physics_process(_delta):
	pause()
	movement()
	move_and_slide()


## Handles movement
func movement():
	var input_vector : Vector2 = Input.get_vector("left", "right", "up", "down")

	set_facing(input_vector)

	if not Input.is_action_pressed("run"):
		velocity = input_vector * SPEED
	else:
		velocity = input_vector * RUN_SPEED


## Set facing_direction depending on the input
func set_facing(input_vector : Vector2):
	var signed_vector : Vector2 = sign(input_vector)

	set_occluder(signed_vector)

	if signed_vector.y == 1:
		facing_direction = "bottom"
	elif signed_vector.y == -1:
		facing_direction = "top"
	elif signed_vector.x == 1:
		facing_direction = "right"
	elif signed_vector.x == -1:
		facing_direction = "left"

	if input_vector == Vector2.ZERO or velocity == Vector2.ZERO:
		doll.play("idle_" + facing_direction)
	else:
		doll.play("walk_" + facing_direction)


## Set light occluders based on the input
func set_occluder(signed_vector : Vector2):
	if signed_vector != Vector2.ZERO:
		occluder_v.visible = signed_vector.x != 0
		occluder_h.visible = signed_vector.y != 0


## Open the pause menu
func pause():
	if Input.is_action_just_pressed("pause"):
		add_child(PAUSE_MENU.instantiate())
