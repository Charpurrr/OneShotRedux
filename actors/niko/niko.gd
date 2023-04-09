extends CharacterBody2D

var speed = 100

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	match input_vector:
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

