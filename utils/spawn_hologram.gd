class_name SpawnPointHolorgram
extends Sprite2D
## In-editor graphic that represents the spawn point location for a room.


## What direction Niko should face after spawning here.
@export var spawn_facing := Vector2.DOWN


func _ready():
	visible = false
