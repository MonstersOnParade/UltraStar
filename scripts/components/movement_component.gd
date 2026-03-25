class_name MovementComponent extends Node

@export var characterBody: CharacterBody2D

# Default Configuration for Kirby
@export var max_sprinting_speed: float = 9000
@export var max_walking_speed: float = 7000
@export var walk_acceleration: float = 24000
@export var sprint_accelerations: float = 36000
@export var friction: float = 30000.0
@export var gravity: float = 10000
@export var instantMaxSpeed: bool =false
#Only Kirby,Helpers and some AI can jump. Most AI can't jump, thus false by default
@export var canJump: bool = false
#Only Kirby and parasol/helpers enemies can float.  Most AI can't float, thus false by default
@export var canFloat: bool = false

#This really only matters if the character can jump, like Kirby or the helpers. But some AI can too
@export var jump_force: float = -6000
@export var coyote_time: float = 0.1
@export var jump_buffer: float = 0.1
@export var jump_length: float = 0.5
@export var is_helper: bool = false

#Used for calculating various jump related timings
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var wants_jump: bool = false
var is_holding_jump: bool = false
var jumping_timer: float = 0.0


#Again only matters if the character can float
@export var float_force: float = 3.0
@export var max_float_time: float = 2.0
@export var float_regen_rate: float = 1.0

var current_float_time: float = 0.0
var is_floating: bool = false

var isSprinting: bool = false
#determines which direction the character is currently moving, if it is moving
var velocity: Vector2 = Vector2.ZERO
#determines which direction the character is facing - might move this to an animation component later
var isRight: bool = true

func tick(delta:float) -> void:
	if characterBody == null:
		return
	
	update_timers(delta)
	
	
	
		
	#apply gravity 
	if not characterBody.is_on_floor():
		if not is_floating:
			if is_holding_jump:
				#does not apply gravity if the jump button is held and the timer is not yet below 0
				if jumping_timer > 0:
					jumping_timer -= delta
				else:
					#characterBody.velocity += characterBody.get_gravity() * delta * gravity
					#velocity += characterBody.get_gravity() * delta * gravity
					velocity.y += delta * gravity
			else:
				jumping_timer = 0
				velocity.y += delta * gravity
				#characterBody.velocity += characterBody.get_gravity() * delta * gravity
				#velocity += characterBody.get_gravity() * delta * gravity
	
	if wants_jump:
		try_jump(delta)
	
	if characterBody.is_on_floor():
		coyote_timer = coyote_time
	
	characterBody.velocity = velocity * delta
	#characterBody.apply_floor_snap()
	characterBody.move_and_slide()
	


#checks if a jump can be performed
func can_jump() -> bool:
	if is_helper or characterBody.is_on_floor() or coyote_timer > 0:
		return true
	else:
		return false

#checks if a jump can occur, then does it if can
func try_jump(delta:float) -> void:
	if can_jump():
		perform_jump(delta)

#applies the jump force to the y velocity
func perform_jump(delta:float) -> void:
	velocity.y = jump_force
	jumping_timer = jump_length

#updates all jumping related timers
func update_timers(delta:float) -> void:
	if coyote_timer > 0:
		coyote_timer -= delta
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

#moves the character based on provided input direction
func move_horizontal(input_direction: float, delta: float) -> void:
	if input_direction != 0:
		if isSprinting:
			if instantMaxSpeed:
				velocity.x = input_direction * max_sprinting_speed
			else:
				velocity.x = move_toward(velocity.x, input_direction * max_sprinting_speed, sprint_accelerations * delta)
		else:
			if instantMaxSpeed:
				velocity.x = input_direction * max_walking_speed
			else:
				velocity.x = move_toward(velocity.x, input_direction * max_walking_speed, walk_acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

#Applies a force vector, for example knockback
func add_force(force:Vector2) -> void:
	velocity += force
