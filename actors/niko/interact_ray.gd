class_name InteractRay
extends RayCast2D
## Raycast for detecting interactable objects.


@onready var context: AnimatedSprite2D = %ContextPopup
@onready var niko: CharacterBody2D = get_parent()

const FADE_STEP: float = 0.2

var dialog_box_scene: PackedScene = preload("res://ui/textbox/dialog.tscn")


func _physics_process(_delta):
	if (is_colliding() and context.modulate.a != 1) and not niko.in_dialogue:
		context.modulate.a = min(context.modulate.a + FADE_STEP, 1)
	elif (not is_colliding() and context.modulate.a != 0) or niko.in_dialogue:
		context.modulate.a = max(context.modulate.a - FADE_STEP, 0)


func _input(_event):
	if niko.in_dialogue == true or not is_colliding(): return

	if Input.is_action_just_pressed(&"interact"):
		var dialog_box: Node = dialog_box_scene.instantiate()
		var collider: InteractableObject = get_collider().get_parent()

		dialog_box.speaker = collider.speaker
		dialog_box.dialogue = collider.dialogue

		niko.in_dialogue = true
		niko.can_move = false

		niko.wm.ui.add_child(dialog_box)
