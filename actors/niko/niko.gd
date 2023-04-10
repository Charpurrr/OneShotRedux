extends CharacterBody2D

@onready var camera = $Camera2D

var pause = preload("res://ui/pause_screen/pause_screen.tscn")
var speed = 100

func _ready():
	set_limits()

func _physics_process(delta):
	if Input.is_action_just_pressed("Pause"):
		var pm = pause.instantiate()
		add_child(pm)
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	match input_vector: #i hardcoded normalized vectors felt goofy
		Vector2(1, 1):
			input_vector = Vector2(atan(1/1), atan(1/1))
		Vector2(-1, 1):
			input_vector = Vector2(-atan(1/1), atan(1/1))
		Vector2(1, -1):
			input_vector = Vector2(atan(1/1), -atan(1/1))
		Vector2(-1, -1):
			input_vector = Vector2(-atan(1/1), -atan(1/1))
			
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed

	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
func set_limits():
	camera.limit_top = get_parent().limU
	camera.limit_bottom = get_parent().limD
	camera.limit_left = get_parent().limL
	camera.limit_right = get_parent().limR

