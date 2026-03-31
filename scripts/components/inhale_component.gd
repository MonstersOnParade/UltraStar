class_name InhaleComponent extends Node

@export var inhale_range: float = 100.0
@export var inhale_speed: float = 300.0
@export var inhale_area: Area2D

var is_inhaling: bool = false
var inhalable_objects: Array[Node2D]
#var inhaled_object: Node2D

func start_inhale() -> void:
	#don't inhale if we are already inhaling
	if is_inhaling:
		return
	is_inhaling = true
	
	inhalable_objects = get_inhalable_objects()
	if inhalable_objects.size() > 0:
		for inhaled_object: Node2D in inhalable_objects:
			#We check that the node has this method before we popped it into the results
			inhaled_object.get_inhaled()
	if inhalable_objects.size() == 0:
		stop_inhale()

func stop_inhale() -> void:
	is_inhaling = false

func get_inhalable_objects() -> Array:
	var results: Array = []
	if inhale_area.has_overlapping_areas():
		var overlapping: Array[Node2D] = inhale_area.get_overlapping_bodies()
		for overlapped_body:Node2D in overlapping:
			#Might be a better way to do this
			if overlapped_body.has_method("get_inhaled"):
				results.append(overlapped_body)
	return results

func spit_out() -> void:
	if inhalable_objects.size() > 0:
		if inhalable_objects.size() > 1:
			#combine objects into a single larger star
			pass
		else:
			#spit out the exact thing
			pass
	stop_inhale()
