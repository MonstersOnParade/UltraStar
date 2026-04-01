class_name InputComponent extends Node

var move_direction: Vector2 = Vector2.ZERO
var move_horizontal_axis: float = 0.0
var jump_pressed: bool = false
var jump_held: bool = false
var attack_pressed: bool = false
var guard_pressed: bool = false
var helper_pressed: bool = false
var menu_pressed: bool = false
var discard_pressed: bool = false
var pause_pressed: bool = false
#used for sprinting
var is_a_direction_pressed: bool = false
var left_pressed: bool = false
var right_pressed: bool = false

func update() -> void:
	move_direction = Input.get_vector("Move Left","Move Right","Move Up","Move Down")
	move_horizontal_axis = Input.get_axis("Move Left","Move Right")
	left_pressed = Input.is_action_just_pressed("Move Left")
	right_pressed = Input.is_action_just_pressed("Move Right")
	if left_pressed or right_pressed:
		is_a_direction_pressed = true
	else:
		is_a_direction_pressed = false	
	jump_pressed = Input.is_action_just_pressed("Jump")
	jump_held = Input.is_action_pressed("Jump")
	attack_pressed = Input.is_action_pressed("Attack")
	guard_pressed = Input.is_action_pressed("Guard")
	helper_pressed = Input.is_action_just_pressed("Helper Button")
	menu_pressed = Input.is_action_just_pressed("Menu")
	discard_pressed = Input.is_action_just_pressed("Discard")
	pause_pressed = Input.is_action_just_pressed("Pause")
	pass
