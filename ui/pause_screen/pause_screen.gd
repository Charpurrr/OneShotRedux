extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	await(get_tree().create_timer(0.1)).timeout
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = false
		queue_free()
