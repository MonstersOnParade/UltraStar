class_name Kirby extends CharacterBody2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var animation_component: AnimationComponent = %AnimationComponent



func _physics_process(delta: float) -> void:
	#handles controls
	input_component.update()
	
	movement_component.move_horizontal(input_component.move_horizontal_axis,delta)
	movement_component.wants_jump = input_component.jump_pressed
	movement_component.is_holding_jump = input_component.jump_held
	movement_component.tick(delta)
	
	if input_component.move_horizontal_axis < -0.1:
		animation_component.flipSprite(true)
	elif input_component.move_horizontal_axis > 0.1:
		animation_component.flipSprite(false)
		
	
	pass
