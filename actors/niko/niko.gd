class_name Niko
extends CharacterBody2D
# Player class for Niko


@onready var doll : AnimatedSprite2D = $Doll

@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var interact_ray : RayCast2D = $InteractRay

@onready var occluder_h : LightOccluder2D = $LightOccluderHorizontal
@onready var occluder_v : LightOccluder2D = $LightOccluderVertical

const PAUSE_MENU : PackedScene = preload("res://ui/pause_screen/pause_screen.tscn")

const RUN_SPEED : int = 100
const SPEED : int = 50

var facing_direction : StringName = "down" # Direction Niko is facing (string)
var facing_vector : Vector2 = Vector2.ZERO # Direction Niko is facing (Vector2)

var input_vector : Vector2 # Current directional input's vector

var warped : bool # Check if Niko has recently warped

var can_move : bool = true


func _physics_process(_delta):
	pause()
	movement()
	move_and_slide()

	for collide in get_slide_collision_count():
		print(get_slide_collision(collide).get_normal())

	set_animation()

	if can_move == true:
		input_vector = Input.get_vector("left", "right", "up", "down")
	else:
		input_vector = Vector2(0, 0)


## Handles movement
func movement():
	set_facing()

	if not Input.is_action_pressed("run"):
		doll.speed_scale = 1
		velocity = input_vector * SPEED
	else:
		doll.speed_scale = 2
		velocity = input_vector * RUN_SPEED


## Set facing_direction depending on the input
func set_facing(): # IMPROPER UPDATES TO INTERACT RAY (03/10)
	var signed_vector : Vector2 = sign(input_vector)

	set_occluder(signed_vector)

	if signed_vector.dot(facing_vector) <= 0:
		facing_vector = signed_vector

		if facing_vector.x != 0:
			facing_vector.y = 0

		if facing_vector != Vector2.ZERO:
			upd_facing_direction(facing_vector)

		interact_ray.target_position = facing_vector * Vector2(8.5, 5)


## Update Niko's facing_direction
func upd_facing_direction(new_vector : Vector2):
	facing_direction = get_direction_str(new_vector)


## Get the directional string associated with vector
func get_direction_str(vector : Vector2) -> String:
	match vector:
		Vector2.DOWN:
			return "down"
		Vector2.UP:
			return "up"
		Vector2.RIGHT:
			return "right"
		Vector2.LEFT:
			return "left"
		_:
			return ""


## Apply the correct animations to Niko
func set_animation():
	var previous_frame = doll.frame
	var previous_frame_progress = doll.frame_progress

	if input_vector == Vector2.ZERO or velocity.is_equal_approx(Vector2.ZERO):
		doll.play("idle_" + facing_direction)
	else:
		doll.set_frame_and_progress(previous_frame, previous_frame_progress)
		doll.play("walk_" + facing_direction)


## Set light occluders based on the input
func set_occluder(signed_vector : Vector2):
	if signed_vector != Vector2.ZERO:
		occluder_v.visible = facing_direction == "left" or facing_direction == "right"
		occluder_h.visible = facing_direction == "up" or facing_direction == "down"


## Open the pause menu
func pause():
	if Input.is_action_just_pressed("pause"):
		add_child(PAUSE_MENU.instantiate())
