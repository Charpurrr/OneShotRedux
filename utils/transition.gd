class_name TransitionEffect
extends CanvasLayer
## Handles the visual transitions between rooms.


@onready var niko : CharacterBody2D = %Niko

@onready var color_rect : ColorRect = $ColorRect

var is_transitioning : bool = false


func fade_out(previous_room : Node2D):
	is_transitioning = true

	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1, 0.3)
	await tween.finished

	previous_room.queue_free()


func fade_in(new_room : Node2D):
	await new_room.ready

	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0, 0.3)
	await tween.finished

	is_transitioning = false
