class_name MovementComponent extends Node

@export var characterBody: CharacterBody2D

# Default Configuration for Kirby
@export var max_speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0
@export var gravity: float = 980.0
#Only Kirby,Helpers and some AI can jump. Most AI can't jump, thus false by default
@export var canJump: bool = false
#Only Kirby and parasol/helpers enemies can float.  Most AI can't float, thus false by default
@export var canFloat: bool = false

#This really only matters if the character can jump, like Kirby or the helpers. But some AI can too
@export var jump_force: float = 500.0
@export var coyote_time: float = 0.1
@export var jump_buffer: float = 0.1

#Used for calculating various jump related timings
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

#Again only matters if the character can float
@export var float_force: float = 300.0
@export var max_float_time: float = 2.0
@export var float_regen_rate: float = 1.0

var current_float_time: float = 0.0
var is_floating: bool = false


#determines which direction the character is currently moving, if it is moving
var velocity: Vector2 = Vector2.ZERO
#determines which direction the character is facing - might move this to an animation component later
var isRight: bool = true
