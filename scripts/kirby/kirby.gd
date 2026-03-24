class_name Kirby extends CharacterBody2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent


func _physics_process(delta: float) -> void:
	#handles controls
	input_component.update()
	pass
