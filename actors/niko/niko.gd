class_name Niko
extends CharacterBody2D
# Player class for Niko


@onready var doll : AnimatedSprite2D = $Doll
@onready var camera : Camera2D = $Camera2D

@onready var occluder_h : LightOccluder2D = $LightOccluderHorizontal
@onready var occluder_v : LightOccluder2D = $LightOccluderVertical

const PAUSE_MENU : PackedScene = preload("res://ui/pause_screen/pause_screen.tscn")

const RUN_SPEED : int = 100
const SPEED : int = 50

var facing_direction : StringName = "down" # Direction Niko is facing (string)
var facing_vector : Vector2 = Vector2.ZERO # Direction Niko is facing (Vector2)

var input_vector : Vector2 # Current directional input's vector

var warped : bool # Check if Niko has recently warped


func _physics_process(_delta):
	pause()
	movement()
	set_animation()
	move_and_slide()

	input_vector = Input.get_vector("left", "right", "up", "down")


## Handles movement
func movement():
	set_facing()

	if not Input.is_action_pressed("run"):
		velocity = input_vector * SPEED
	else:
		velocity = input_vector * RUN_SPEED


## Set facing_direction depending on the input
func set_facing():
	var signed_vector : Vector2 = sign(input_vector)

	set_occluder(signed_vector)

	if signed_vector.dot(facing_vector) <= 0:
		if signed_vector.y == 1:
			facing_direction = "down"
			facing_vector = Vector2.DOWN
		elif signed_vector.y == -1:
			facing_direction = "up"
			facing_vector = Vector2.UP
		elif signed_vector.x == 1:
			facing_direction = "right"
			facing_vector = Vector2.RIGHT
		elif signed_vector.x == -1:
			facing_direction = "left"
			facing_vector = Vector2.LEFT


## Apply the correct animations to Niko
func set_animation():
	var previous_frame = doll.frame
	var previous_frame_progress = doll.frame_progress

	if input_vector == Vector2.ZERO or velocity == Vector2.ZERO:
		doll.play("idle_" + facing_direction)
	else:
		doll.set_frame_and_progress(previous_frame, previous_frame_progress)
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
