class_name Kirby extends CharacterBody2D

#Collision Shapes
@onready var normal_collision: CollisionShape2D = %"Normal Collision"
@onready var ducking_collision: CollisionShape2D = %"Ducking Collision"
@onready var full_collision: CollisionShape2D = %"Full Collision"
@onready var full_walk_collision: CollisionShape2D = %"Full Walk Collision"
@onready var float_collision: CollisionShape2D = %"Float Collision"



#Components
@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var inhale_component: InhaleComponent = %InhaleComponent
@onready var state_component: StateComponent = %StateComponent
@onready var ability_component: AbilityComponent = %AbilityComponent

#Might be useful later
@export var guard_flash_color:Color = Color.WHITE
@export var hurt_flash_color:Color = Color.RED

func _ready() -> void:
	animation_component.AnimatedSprite.play()

func _physics_process(delta: float) -> void:
	#handles controls
	input_component.update()
	
	if input_component.guard_pressed and is_on_floor():
		health_component.is_guarding = true
	else:
		health_component.is_guarding = false
	
	if not health_component.is_guarding:
		movement_component.wants_sprint = input_component.is_a_direction_pressed
		movement_component.move_horizontal(input_component.move_horizontal_axis,delta)
		movement_component.wants_jump = input_component.jump_pressed
		movement_component.is_holding_jump = input_component.jump_held
	else:
		movement_component.move_horizontal(0,delta)
	movement_component.tick(delta)
	determine_animation()
	determine_collision()

func determine_state() -> void:
	if is_instance_valid(inhale_component.current_inhaled_object):
		state_component.CurrentState = state_component.StateMachine.Full
		movement_component.is_full = true
	else:
		state_component.CurrentState = state_component.StateMachine.Normal
		movement_component.is_full = false

#swaps Kirby's collision asset based on current state
func determine_collision() ->void:
	match state_component.CurrentState:
		state_component.StateMachine.Normal:
			#Always set this to disabled if not in that state
			full_collision.disabled = true
			if movement_component.is_ducking or movement_component.is_sliding:
				normal_collision.disabled = true
				ducking_collision.disabled = false
				float_collision.disabled = true
			elif movement_component.is_floating:
				normal_collision.disabled = true
				ducking_collision.disabled = true
				float_collision.disabled = false
			else:
				normal_collision.disabled = false
				ducking_collision.disabled = true
				float_collision.disabled = true
		state_component.StateMachine.Full:
			normal_collision.disabled = true
			ducking_collision.disabled = true
			float_collision.disabled = true
			if abs(velocity.x) > 0:
				full_walk_collision.disabled = false
				full_collision.disabled = true
			else:
				full_walk_collision.disabled = true
				full_collision.disabled = false

#This will need to be improved later
func determine_animation() -> void:
	
	if input_component.move_horizontal_axis < -0.1:
		animation_component.flipSprite(true)
	elif input_component.move_horizontal_axis > 0.1:
		animation_component.flipSprite(false)
	
	#swap animations based on Kirby's current ability
	match ability_component.CurrentAbility:
		ability_component.AbilityEnum.Normal:
			normal_kirby_animatations()

func normal_kirby_animatations() -> void:
	match  state_component.CurrentState:
		state_component.StateMachine.Normal:
			if is_on_floor():
				if abs(movement_component.velocity.x) > 0:
					if movement_component.is_sprinting:
						animation_component.AnimatedSprite.play("Run")
					elif movement_component.is_sliding:
						animation_component.AnimatedSprite.play("Slide")
					else:
						animation_component.AnimatedSprite.play("Walk")
				else:
					if movement_component.is_ducking:
						animation_component.AnimatedSprite.play("Duck")
					else:
						animation_component.AnimatedSprite.play("Idle")
	
			if movement_component.can_jump() and movement_component.wants_jump and not movement_component.is_floating:
				animation_component.AnimatedSprite.play("Jump")
	
			if movement_component.velocity.y > 0 and not movement_component.is_floating and not is_on_floor():
				animation_component.AnimatedSprite.play("Fall")
	
			if movement_component.velocity.y > 0 and movement_component.is_floating and not is_on_floor():
				animation_component.AnimatedSprite.play("Float")
		
			if movement_component.wants_jump and movement_component.is_floating:
				animation_component.AnimatedSprite.play("Float Flap")
	
			if health_component.is_guarding:
				animation_component.AnimatedSprite.play("Guard")
				
		state_component.StateMachine.Full:
			if is_on_floor():
				if abs(movement_component.velocity.x) > 0:
					if movement_component.is_sprinting:
						animation_component.AnimatedSprite.play("Full Run")
					elif movement_component.is_sliding:
						animation_component.AnimatedSprite.play("Full Slide")
					else:
						animation_component.AnimatedSprite.play("Full Walk")
				else:
					if movement_component.is_ducking:
						animation_component.AnimatedSprite.play("Full Duck")
					else:
						animation_component.AnimatedSprite.play("Full Idle")
