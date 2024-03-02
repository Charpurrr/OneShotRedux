class_name Dialog
extends CanvasLayer
## Character dialogue.[br][br]
## Dialog includes a tag system that you can define custom behaviour to.[br]
## [u]WARNING: When making use of tags, seperate them on newlines to avoid unintended behaviour![/u][br][br]
## You can call for a new dialog prompt with « [new] »,[br]
## [i]This queues a second dialog prompt that continues the inputed text.[/i][br]
## a character portait with « [chr(animation: StringName)] »,[br]
## [i]This sets a character portrait graphic whenever read: [u]you can change expressions
## while text is still being written.[/u][/i][br]
## and set text speed with « [spd(new_speed: int)] »[br]
## [i]This makes characters appear at the rate of new_speed.[/i][br][br]
## EXAMPLE: [br][br][i]
##[spd(3)][br][chr(nik_neutral)][br]This is the first dialog prompt with a text speed of 3fps and a neutral character portrait of Niko.[br]
## [new][br][spd(6)][br][chr(nik_silly)][br]This is the second dialog prompt with a text speed of 6fps and a silly character portrait of Niko.

@onready var wm: WorldMachine = $/root/WorldMachine

@onready var prog_graphic: AnimatedSprite2D = $Progress
@onready var text_label: Label = $Text

## Time between the ticking sound effects.
@export var sfx_time: int = 5
var sfx_timer: int = 0

var sfx: AudioStreamWAV = preload("res://sound/sfx/text_tick.wav")

## Timer for text speed.
var read_timer: int = 0

## Whether or not the next line can start being handled.
var can_progress: bool = false
## Whether or not the next dialog box can be prompted.
var can_continue: bool = false

var text_array: PackedStringArray

## What line of the input text is being handled. (From zero)
var line_pos: int = 0

#region INPUT VARIABLES, THESE ARE SET BY THE DIALOG CALLER.
var text: String
## Time (in frames) between characters.
var speed: int = 2
#endregion


func _ready():
	text_label.visible_characters = 0
	text_array = text.split("\n")


func _process(_delta):
	_text_progress()
	_apply_tags()

	text_label.text = text_array[line_pos]

	if can_continue:
		return

	if can_progress:
		line_pos = min(line_pos + 1, text_array.size() - 1)

		can_progress = false

	_characters_appear()
	_ticking_sfx()


func _input(_event):
	if Input.is_action_just_pressed(&"interact"):
		text_label.visible_characters = text_array[line_pos].length()


## Apply the tags if there are any. See class documentation for elaborated info on tags.
func _apply_tags():
	var regex:= RegEx.new()
	regex.compile("^[.*]$")

	var result: RegExMatch = regex.search(text_array[line_pos])

	if result != null:
		print(result)
		# remove the result from the array
		# can_progress = true


## Handles appearing character logic.
func _characters_appear():
	read_timer = max(read_timer - 1, 0)

	if read_timer == 0 and text_label.visible_characters != text_array[line_pos].length():
		text_label.visible_characters += 1
		read_timer = speed


## Handles the text tick sound effect.
func _ticking_sfx():
	sfx_timer = max(sfx_timer - 1, 0)

	if sfx_timer == 0:
		SFX.play_sfx(sfx, self, &"SFX")

		sfx_timer = sfx_time


## Handles dialogue progression.
func _text_progress():
	can_continue = text_label.visible_characters == text_array[line_pos].length()
	prog_graphic.visible = can_continue

	if can_continue and Input.is_action_just_pressed(&"interact"):
		if line_pos == text_array.size() - 1:
			wm.niko.in_dialogue = false
			wm.niko.can_move = true

			queue_free()

		text_label.visible_characters = 0
		can_progress = true
