class_name InteractRay
extends RayCast2D
## Raycast for detecting interactable objects.


@onready var context: AnimatedSprite2D = %ContextPopup

var dialog_box_scene: PackedScene = preload("res://ui/textbox/dialog.tscn")


func _process(_delta):
	context.visible = is_colliding()

	if not is_colliding():
		return

	if Input.is_action_just_pressed(&"interact"):
		var dialog_box: Node = dialog_box_scene.instantiate()
		var collider: InteractableObject = get_collider().get_parent()

		dialog_box.text = collider.text

		get_parent().wm.ui.add_child(dialog_box)
