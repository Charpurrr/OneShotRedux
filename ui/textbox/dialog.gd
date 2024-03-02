class_name Dialog
extends CanvasLayer
## Character dialogue.


@onready var prog_graphic: AnimatedSprite2D = $Progress
@onready var text_label: Label = $Text

var sfx: AudioStreamWAV = preload("res://sound/sfx/text_tick.wav")

## Timer for text speed.
var read_timer: int = 0

## Time between the ticking sound effects.
const SFX_TIME: int = 5
var sfx_timer: int = 0

var can_progress: bool = false

#region INPUT VARIABLES, THESE ARE SET BY THE DIALOG CALLER.
var text: String
## Time (in frames) between characters.
var speed: int = 2
#endregion


func _ready():
	text_label.visible_characters = 0
	text_label.text = text


func _process(_delta):
	_text_progress()

	if can_progress:
		return

	if Input.is_action_just_pressed(&"interact"):
		text_label.visible_characters = text.length()

	_characters_appear()
	_ticking_sfx()


## Handles appearing character logic.
func _characters_appear():
	read_timer = max(read_timer - 1, 0)

	if read_timer == 0 and text_label.visible_characters != text.length():
		text_label.visible_characters += 1
		read_timer = speed


## Handles the text tick sound effect.
func _ticking_sfx():
	sfx_timer = max(sfx_timer - 1, 0)

	if sfx_timer == 0:
		SFX.play_sfx(sfx, self, &"SFX")

		sfx_timer = SFX_TIME


## Handles dialogue progression.[br]
## [i] NEW DIALOG PROMPT CALLED IN TEXT EDIT WITH: « \new »[br][br]
## EXAMPLE: « "Hello! \new Hi!" »[br]
## OUTPUT: Dialog prompt 1: "Hello!", dialog prompt 2: "Hi!"
func _text_progress():
	can_progress = text_label.visible_characters == text.length()
	prog_graphic.visible = can_progress

	if not can_progress:
		return

	if Input.is_action_just_pressed(&"interact"):
		#prog_graphic.play(&"pressed")
		text_label.visible_characters = 0
	#elif Input.is_action_just_released(&"interact"):
	#else:
		#prog_graphic.play(&"unpressed")
