class_name Dialog
extends CanvasLayer
## Character dialogue.
## 
## [u]Make sure your dialogue is spread across newlines, to avoid unintended behaviour.[/u]
## [br]
## [i]See the example document for more information on the proper usage of tags and syntax.[/i]
## [br]
## [br]
## [u]TAG LIST:[/u]
## [br]
## [br]
## [b]« [chr(animation: StringName)] »[/b]
## [br]
## [i]This makes the character portrait play the corresponding animation as defined by the StringName.
## [br]
## See the Portrait (AnimatedSprite2D) node for an exhaustive list of every available animation.[/i]
## [br]
## [br]
## [b]« [spd(new_speed: int)] »[/b]
## [br]
## [i]This makes characters appear at the rate of the integer. (in frames)[/i]
## [br]
## [br]
## [b]« [pau(pause_time: int)] »[/b]
## [br]
## [i]This makes the text delay for as long as defined by the integer. (in frames)[/i]
## [br]
## [br]
## [b]« [new] »[/b]
## [br]
## [i]This makes the dialogue continue on a new dialog box.
## [br]
## Note that dialogue does not automatically place itself in another box when overflowing 
## the text space of the Text label.[/i]


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

## Array for the remaining dialog lines.
var dialogue_array: PackedStringArray

## What line of the dialog is being handled. (From zero)
var line_pos: int = 0

## How fast characters appear. 
## (Only set this through tags, unless you want to change the default value.)
var speed: int = 2

## How long to delay text for.
## (Only set this through tags.)
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

	# Skipping a dialogue box.
	if Input.is_action_just_pressed(&"interact") and text_label.visible_characters > 0:
		while not can_next_box:
			handle_nextl()

			text_label.visible_characters = text_label.text.length()
			pause_timer = 0

	can_next_line = text_label.visible_characters == text_label.text.length()

	if can_next_box: return
	if pause_timer != 0: return

	if can_next_line: handle_nextl()

	_characters_appear()
	_ticking_sfx()


## Logic for processing and handling the next line in the dialogue.
func handle_nextl():
	if pause_timer != 0: return

	can_next_box = line_pos == dialogue_array.size()

	if not can_next_box:
		var tag: RegExMatch = _check_tag()

		if tag != null:
			_apply_tag(tag)
		else:
			text_label.text = text_label.text + dialogue_array[line_pos]

			line_pos = min(line_pos + 1, dialogue_array.size())
			can_next_line = false


## Check for a tag on this line of the dialogue and return it. 
## See class documentation for elaborated info on tags.
func _check_tag() -> RegExMatch:
	var regex_tag:= RegEx.new()

	# Regex for the brackets (group 0) and its content (group 1).
	regex_tag.compile(r'^\[(.*)\]$') 

	var tag: RegExMatch = regex_tag.search(dialogue_array[line_pos])

	return tag


## Apply a tag if found.
func _apply_tag(tag: RegExMatch):
	var tag_str = tag.get_string(1)

	var regex_val:= RegEx.new()

	# Regex for the parentheses (group 0) and its content (group 1).
	regex_val.compile(r'\((.*)\)') 

	var val: RegExMatch = regex_val.search(tag_str)

	if tag_str == "new":
		_tag_new()

		dialogue_array.remove_at(line_pos)
	else:
		if tag_str.begins_with("chr"):
			_tag_chr(val.get_string(1))
		elif tag_str.begins_with("spd"):
			_tag_spd(int(val.get_string(1)))
		elif tag_str.begins_with("pau"):
			_tag_pau(int(val.get_string(1)))

		dialogue_array.remove_at(line_pos)
		handle_nextl()


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


## Apply the new box tag.
func _tag_new():
	can_next_box = true


## Handles appearing character logic.
func _characters_appear():
	if read_timer == 0 and pause_timer == 0:
		text_label.visible_characters += 1
		read_timer = speed


## Handles the text tick sound effect.
func _ticking_sfx():
	sfx_timer = max(sfx_timer - 1, 0)

	if sfx_timer == 0 and pause_timer == 0:
		SFX.play_sfx(sfx, self, &"SFX")

		sfx_timer = sfx_time


## Handles dialogue progression.
func _text_progress():
	prog_graphic.visible = can_next_box

	if prog_graphic.visible == false:
		prog_graphic.frame = 0

	if can_next_box and Input.is_action_just_pressed(&"interact"):
		dialogue_array = dialogue_array.slice(line_pos)

		if dialogue_array.is_empty():
			end_dialogue()

		line_pos = 0

		text_label.text = ""
		text_label.visible_characters = 0

		can_next_line = true
		can_next_box = false


## End the current conversation.
func end_dialogue():
		wm.niko.in_dialogue = false
		wm.niko.can_move = true

		queue_free()
