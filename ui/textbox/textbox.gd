extends CanvasLayer

@onready var text = $Text

var current_dialogue = 0
var convo = Dialogue.convo1

# Called when the node enters the scene tree for the first time.
func _ready():
	text.visible_characters = 0
	current_dialogue = 0
	new_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Skip"):
		text.visible_characters = -1
	if Input.is_action_just_pressed("Next") && (text.visible_characters >= len(convo[current_dialogue]) || text.visible_characters == -1 && current_dialogue <= len(convo)- 1):
		current_dialogue += 1
		new_text()
	if current_dialogue == len(convo):
		queue_free()
	
func new_text(speed : float = 0.05):
	text.visible_characters = 0
	if current_dialogue < len(convo):
		var words = convo[current_dialogue]
		text.text = words
		while text.visible_characters < len(words) && text.visible_characters != -1:
			text.visible_characters += 1
			await(get_tree().create_timer(speed)).timeout

				
