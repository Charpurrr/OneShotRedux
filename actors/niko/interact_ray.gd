class_name InteractRay
extends RayCast2D
## Raycast for detecting interactable objects.


@onready var context: AnimatedSprite2D = %ContextPopup
@onready var niko: CharacterBody2D = get_parent()

var dialog_box_scene: PackedScene = preload("res://ui/textbox/dialog.tscn")


func _process(_delta):
	context.visible = is_colliding()


func _input(_event):
	if niko.in_dialogue == true or not is_colliding(): return

	if Input.is_action_just_pressed(&"interact"):
		var dialog_box: Node = dialog_box_scene.instantiate()
		var collider: InteractableObject = get_collider().get_parent()

		dialog_box.speaker = collider.speaker
		dialog_box.text = collider.text

		niko.in_dialogue = true
		niko.can_move = false

		niko.wm.ui.add_child(dialog_box)
