class_name PatrolComponent extends Node

@export var characterBody: CharacterBody2D
@export var patrol_range: float = 100.0
var direction: float = 1

var starting_position: Vector2

func _ready() -> void:
	starting_position = characterBody.global_position

func tick() -> void:
	if abs(characterBody.global_position.x - starting_position.x) >= patrol_range:
		direction *= -1
