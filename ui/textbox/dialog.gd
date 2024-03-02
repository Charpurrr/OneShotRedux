class_name Dialog
extends CanvasLayer
## Character dialogue.[br][br]
## Dialog includes a tag system that you can define custom behaviour to.[br]
## [u]WARNING: When making use of tags, seperate them on newlines to avoid unintended behaviour![/u][br][br]
## a character portrait with « [chr(animation: StringName)] »,[br]
## [i]This makes the character portrait play the corresponding animation as defined by the StringName.[/i][br]
## and set text speed with « [spd(new_speed: int)] »[br]
## [i]This makes characters appear at the rate of new_speed.[/i][br][br]
## EXAMPLE: [br][br][i]
##[spd(3)][br][chr(nik_neutral)][br]This is the first dialog prompt with a text speed of 3fps and a neutral character portrait of Niko.[br]
## [new][br][spd(6)][br][chr(nik_silly)][br]This is the second dialog prompt with a text speed of 6fps and a silly character portrait of Niko.

@onready var wm: WorldMachine = $/root/WorldMachine

@onready var prog_graphic: AnimatedSprite2D = $Progress
@onready var portrait: AnimatedSprite2D = $Portrait
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

	if can_continue: return

	if can_progress:
		line_pos = min(line_pos + 1, text_array.size() - 1)

		can_progress = false

	_characters_appear()
	_ticking_sfx()


func _input(_event):
	if Input.is_action_just_pressed(&"interact") and not can_continue:
		text_label.visible_characters = text_array[line_pos].length()


## Apply the tags if there are any. See class documentation for elaborated info on tags.
func _apply_tags():
	var regex_tag:= RegEx.new()
	regex_tag.compile(r'^\[(.*)\]$') # Regex for the brackets (group 0) and its content (group 1).

	var tag: RegExMatch = regex_tag.search(text_array[line_pos])

	if tag == null: return

	var tag_str = tag.get_string(1)

	var regex_val:= RegEx.new()
	regex_val.compile(r'\((.*)\)') # Regex for the parentheses (group 0) and its content (group 1).

	var val: RegExMatch = regex_val.search(tag_str)

	if tag_str.begins_with("chr"):
		_tag_chr(val.get_string(1))
	elif tag_str.begins_with("spd"):
		_tag_spd(int(val.get_string(1)))


## Apply the character portrait tag.
func _tag_chr(animation: StringName):
	portrait.play(animation)
	text_array.remove_at(line_pos)


## Apply the read speed tag.
func _tag_spd(new_speed: int):
	speed = new_speed
	text_array.remove_at(line_pos)


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
	prog_graphic.visible = can_continue

	if can_continue and Input.is_action_just_pressed(&"interact"):
		if line_pos == text_array.size() - 1:
			wm.niko.in_dialogue = false
			wm.niko.can_move = true

			queue_free()

		text_label.visible_characters = 0
		can_progress = true

	can_continue = text_label.visible_characters == text_array[line_pos].length()
