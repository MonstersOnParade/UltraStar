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
	
	movement_component.wants_sprint = input_component.is_a_direction_pressed
	movement_component.move_horizontal(input_component.move_horizontal_axis,delta)
	movement_component.wants_jump = input_component.jump_pressed
	movement_component.is_holding_jump = input_component.jump_held
	movement_component.tick(delta)
	
	determine_animation()

#This will need to be improved later
func determine_animation() -> void:
	
	if input_component.move_horizontal_axis < -0.1:
		animation_component.flipSprite(true)
	elif input_component.move_horizontal_axis > 0.1:
		animation_component.flipSprite(false)
	
	if is_on_floor():
		if abs(movement_component.velocity.x) > 0:
			if movement_component.is_sprinting:
				animation_component.AnimatedSprite.play("Run")
			else:
				animation_component.AnimatedSprite.play("Walk")
		else:
			animation_component.AnimatedSprite.play("Idle")
	
	if movement_component.can_jump() and movement_component.wants_jump and not movement_component.is_floating:
		animation_component.AnimatedSprite.play("Jump")
	
	if movement_component.velocity.y > 0 and not movement_component.is_floating and not is_on_floor():
		animation_component.AnimatedSprite.play("Fall")
