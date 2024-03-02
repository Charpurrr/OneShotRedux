class_name Dialog
extends CanvasLayer
## Character dialogue.[br]
## You can call for a new dialog prompt with « [new] »,[br]
## [i]This queues a second dialog prompt that continues the inputed text[/i][br]
## a character portait with « [chr(animation: StringName)] »,[br]
## [i]This sets a character portrait graphic whenever read: [u]you can change expressions
## while text is still being written.[/u][/i][br]
## and set text speed with « [spd(new_speed: int)] »[br]
## [i]This makes characters appear at the rate of new_speed.[/i][br][br]
## EXAMPLE: [br][br][i]
##[spd(3)][chr(nik_neutral)] This is the first dialog prompt with a text speed of 3fps and a neutral character portrait of Niko. 
## [new][spd(6)][chr(niko_silly)] This is the second dialog prompt with a text speed of 6fps and a silly character portrait of Niko.


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


## Handles dialogue progression.
func _text_progress():
	can_progress = text_label.visible_characters == text.length()
	prog_graphic.visible = can_progress

	if can_progress and Input.is_action_just_pressed(&"interact"):
		text_label.visible_characters = 0


func _apply_tags():
	var regex:= RegEx.new()
	regex.search_all(r'')
