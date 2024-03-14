class_name PauseMenu
extends CanvasLayer
## Class for the pause menu.


@onready var ui: UserInterface = get_parent()
@onready var time_label: Label = %Time

## The current local system time as a dictionary. (hour, minute, second)
var time: Dictionary


func _process(_delta):
	time = Time.get_time_dict_from_system()

	time_label.text = "%02d : %02d" % [time.hour, time.minute]
