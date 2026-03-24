class_name AnimationComponent extends Node

@export var AnimatedSprite: AnimatedSprite2D

func flipSprite(isFacingLeft: bool) -> void:
	if AnimatedSprite != null:
		AnimatedSprite.flip_h = isFacingLeft
