class_name InteractRay
extends RayCast2D
# Raycast for detecting interactable objects


func _process(_delta):
	if is_colliding():
		
