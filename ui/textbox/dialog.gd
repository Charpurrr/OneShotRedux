class_name Dialog
extends CanvasLayer
## Character dialogue.

@onready var text_label: Label = $Text
var sfx: AudioStreamWAV = preload("res://sound/sfx/text_tick.wav")

## Timer for text speed.
var read_timer: int = 0

## Time between the ticking sound effects.
const SFX_TIME: int = 5
var sfx_timer: int = 0

#region INPUT VARIABLES, THESE ARE SET BY THE DIALOG CALLER.
var text: String
## Time (in frames) between characters.
var speed: int = 2
#endregion


func _ready():
	text_label.visible_characters = 0
	text_label.text = text


func _process(_delta):
	read_timer = max(read_timer - 1, 0)
	sfx_timer = max(sfx_timer - 1, 0)

	if not text_label.visible_characters < text.length():
		return

	if read_timer == 0:

		text_label.visible_characters += 1
		read_timer = speed

	if sfx_timer == 0:
		SFX.play_sfx(sfx, self, &"SFX")

		sfx_timer = SFX_TIME
