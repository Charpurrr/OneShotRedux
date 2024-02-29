class_name RoomInfo
extends Node2D
## Class for storing room data.


## Audio track for this room
@export var audio: Resource

## Camera limit (left side)
@export_range(0, 10, 1, "or_greater") var lim_l: int
## Camera limit (right side)
@export_range(0, 10, 1, "or_greater") var lim_r: int
## Camera limit (top side)
@export_range(0, 10, 1, "or_greater") var lim_t: int
## Camera limit (bottom side)
@export_range(0, 10, 1, "or_greater") var lim_b: int

@onready var sp_hologram: Sprite2D = $Warps/SpawnPointHologram
