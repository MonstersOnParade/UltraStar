class_name Kirby extends CharacterBody2D

@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var health_component: HealthComponent = %HealthComponent

func _ready() -> void:
	animation_component.AnimatedSprite.play()

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
	
	determine_animation()

#This will need to be improved later
func determine_animation() -> void:
	if abs(movement_component.velocity.x) > 0:
		if movement_component.isSprinting:
			animation_component.AnimatedSprite.play("Walk")
		else:
			animation_component.AnimatedSprite.play("Walk")
	else:
		animation_component.AnimatedSprite.play("Idle")
