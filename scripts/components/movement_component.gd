class_name MovementComponent extends Node

@export var characterBody: CharacterBody2D

# Default Configuration for Kirby
@export var max_sprinting_speed: float = 11000
@export var max_walking_speed: float = 7000
@export var walk_acceleration: float = 24000
@export var sprint_accelerations: float = 36000
@export var friction: float = 30000.0
@export var gravity: float = 10000
@export var float_gravity: float = 5000

#probably only useful for debug
@export var instantMaxSpeed: bool =false

#Only Kirby,Helpers and some AI can jump. Most AI can't jump, thus false by default
@export var can_we_jump: bool = false
#Only Kirby and parasol/helpers enemies can float.  Most AI can't float, thus false by default
@export var can_we_float: bool = false

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


#float related
@export var float_force: float = -3500.0
@export var max_float_time: float = 2.0
@export var float_regen_rate: float = 1.0

var current_float_time: float = 0.0
var is_floating: bool = false

#sprint related
@export var max_start_sprinting_timer: float = 1.0
@export var sprint_timer: float = 0.0
var is_sprinting: bool = false
var wants_sprint: bool = false

#determines which direction the character is currently moving, if it is moving
var velocity: Vector2 = Vector2.ZERO

func tick(delta:float) -> void:
	if characterBody == null:
		return
	
	update_timers(delta)
	
	if wants_sprint:
		try_sprint(delta)
	
	#apply gravity 
	apply_gravity(delta)
	
	if wants_jump:
		try_jump(delta)
	
	if characterBody.is_on_floor():
		coyote_timer = coyote_time
		is_floating = false
	
	characterBody.velocity = velocity * delta
	#characterBody.apply_floor_snap()
	characterBody.move_and_slide()

#updates all timers
func update_timers(delta:float) -> void:
	if coyote_timer > 0:
		coyote_timer -= delta
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if sprint_timer >= 0:
		sprint_timer -= delta

func apply_gravity(delta: float) -> void:
	if not characterBody.is_on_floor():
		if is_floating:
			velocity.y += delta * float_gravity
		elif not is_floating:
			if is_holding_jump:
				#does not apply gravity if the jump button is held and the timer is not yet below 0
				if jumping_timer > 0:
					jumping_timer -= delta
				else:
					velocity.y += delta * gravity
			else:
				jumping_timer = 0
				velocity.y += delta * gravity

func try_sprint(delta: float) -> void:
	if can_sprint():
		start_sprinting(delta)
	else:
		is_sprinting = false

func can_sprint() -> bool:
	if is_sprinting and characterBody.is_on_floor() or sprint_timer > 0.0 and characterBody.is_on_floor():
		return true
	if sprint_timer <= 0.0:
		sprint_timer = max_start_sprinting_timer
		return false
	
	#essentially the default case
	return false

func start_sprinting(delta: float) -> void:
	is_sprinting = true

#checks if a jump can occur, then does it if can
func try_jump(delta:float) -> void:
	#This is the global parameter
	if can_we_jump:
		#this is actually checking if we currently can jump
		if can_jump():
			perform_jump(delta)
		elif not characterBody.is_on_floor():
			perform_float(delta)

#checks if a jump can be performed
func can_jump() -> bool:
	if is_helper or characterBody.is_on_floor() or coyote_timer > 0:
		return true
	else:
		return false

#applies the jump force to the y velocity
func perform_jump(delta:float) -> void:
	velocity.y = jump_force
	jumping_timer = jump_length

func perform_float(delta:float) -> void:
	is_floating = true
	velocity.y = float_force

#moves the character based on provided input direction
func move_horizontal(input_direction: float, delta: float) -> void:
	if input_direction != 0:
		if is_sprinting:
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
		is_sprinting = false

#Applies a force vector, for example knockback
func add_force(force:Vector2) -> void:
	velocity += force
