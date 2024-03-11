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
@onready var text_label: Label = $Text

@onready var portrait: AnimatedSprite2D = $Portrait
@onready var speaker_label: Label = $Speaker
@onready var icon: AnimatedSprite2D = $Icon

## Time between the ticking sound effects.
@export var sfx_time: int = 5
var sfx_timer: int = 0

var sfx: AudioStreamWAV = preload("res://sound/sfx/text_tick.wav")

## Timer for text speed.
var read_timer: int = speed

## Whether or not the next line can start being handled.
var can_next_line: bool = true
## Whether or not the next dialog box can be prompted.
var can_next_box: bool = false

## Array for the every newline in the dialogue input variable.
var dialogue_array: PackedStringArray

## What line of the input text is being handled. (From zero)
var line_pos: int = 0

## How fast characters appear. 
## (Only set this through tags, unless you want to change the default value.)
var speed: int = 2

## How long to delay text for.
## ## (Only set this through tags.)
var pause_time: int
var pause_timer: int

#region INPUT VARIABLES, THESE ARE SET BY THE COLLIDER.
var speaker: StringName
var dialogue: String
#endregion


func _ready():
	speaker_label.text = speaker + ".EXE"
	icon.animation = speaker

	text_label.visible_characters = 0
	dialogue_array = dialogue.split("\n")


func _process(_delta):
	_text_progress()

	pause_timer = max(pause_timer - 1, 0)
	read_timer = max(read_timer - 1, 0)

	if Input.is_action_just_pressed(&"interact") and not can_next_box and text_label.visible_characters > 0:
		while line_pos != dialogue_array.size():
			handle_nextl()

		text_label.visible_characters = text_label.text.length()
		pause_timer = 0

	can_next_line = text_label.visible_characters == text_label.text.length()
	
	if can_next_line: 
		handle_nextl()

	if can_next_box or pause_timer != 0: 
		return

	_characters_appear()
	_ticking_sfx()


## Logic for processing and handling the next line in the dialogue.
func handle_nextl():
	can_next_box = line_pos == dialogue_array.size()

	_apply_tags()

	if !can_next_box:
		text_label.text = text_label.text + dialogue_array[line_pos]
		line_pos = min(line_pos + 1, dialogue_array.size())
		can_next_line = false


## Apply the tags if there are any. See class documentation for elaborated info on tags.
func _apply_tags():
	if can_next_box: return

	var regex_tag:= RegEx.new()
	regex_tag.compile(r'^\[(.*)\]$') # Regex for the brackets (group 0) and its content (group 1).

	var tag: RegExMatch = regex_tag.search(dialogue_array[line_pos])

	if tag == null: return

	var tag_str = tag.get_string(1)

	var regex_val:= RegEx.new()
	regex_val.compile(r'\((.*)\)') # Regex for the parentheses (group 0) and its content (group 1).

	var val: RegExMatch = regex_val.search(tag_str)

	if tag_str.begins_with("chr"):
		_tag_chr(val.get_string(1))
	elif tag_str.begins_with("spd"):
		_tag_spd(int(val.get_string(1)))
	elif tag_str.begins_with("pau"):
		_tag_pau(int(val.get_string(1)))

	dialogue_array.remove_at(line_pos)


## Apply the character portrait tag.
func _tag_chr(animation: StringName):
	portrait.play(animation)


## Apply the read speed tag.
func _tag_spd(new_speed: int):
	speed = new_speed


## Apply the pause (or delay) tag.
func _tag_pau(time: int):
	pause_time = time
	pause_timer = pause_time


## Handles appearing character logic.
func _characters_appear():
	if read_timer == 0 and pause_timer == 0:
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
	prog_graphic.visible = can_next_box

	if prog_graphic.visible == false:
		prog_graphic.frame = 0

	if can_next_box and Input.is_action_just_pressed(&"interact"):
		text_label.visible_characters = 0
		can_next_line = true
		can_next_box = false

		wm.niko.in_dialogue = false
		wm.niko.can_move = true

		queue_free()
