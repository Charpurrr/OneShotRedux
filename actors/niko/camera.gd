class_name Camera
extends Camera2D
# Controling and managing the camera


func _ready():
	limit_bottom = RoomCoordinator.current_room.lim_b
	limit_right = RoomCoordinator.current_room.lim_r
	limit_left = RoomCoordinator.current_room.lim_l
	limit_top = RoomCoordinator.current_room.lim_t
