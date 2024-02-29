class_name WorldMachine
extends Node2D
## Handles loading and interacting with the game world.


@onready var room_coordinator: Node2D = $RoomCoordinator
@onready var transition: CanvasLayer = $Transition
@onready var ui: CanvasLayer = $UI

@onready var niko: CharacterBody2D = %Niko

var areas: Dictionary = {
	"start_house" = preload("res://maps/start_house/start_house.tres"),
}

var default_room: PackedScene = areas["start_house"].rooms["computer_hall"]


func _ready():
	room_coordinator.upd_current_room("start_house", "computer_hall", Vector2.DOWN)
