class_name HealthComponent extends Node

@export var max_health: int = 6
var current_health: int = 6
var is_guarding:bool = false

signal health_changed(new_health: int)
signal has_died()

func take_damage(amount: int) ->void:
	if is_guarding:
		current_health = max(0, current_health - (amount/2))
	else:
		current_health = max(0, current_health - amount)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		has_died.emit()

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health)

#I don't think I'm going to use this for anything but might be useful for something
func get_percent_health() -> float:
	return float(current_health) / max_health
