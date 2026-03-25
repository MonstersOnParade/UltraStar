class_name WaddleDee extends CharacterBody2D

@onready var movement_component: MovementComponent = %MovementComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var patrol_component: PatrolComponent = %PatrolComponent

func _ready() -> void:
	animation_component.AnimatedSprite.play()

func _process(delta: float) -> void:
	patrol_component.tick()
	movement_component.move_horizontal(patrol_component.direction,delta)
	movement_component.tick(delta)
	
	#this should be switched to a signal at some point
	if patrol_component.direction == 1:
		animation_component.flipSprite(false)
	else:
		animation_component.flipSprite(true)
	
