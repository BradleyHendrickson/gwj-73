extends NavigationAgent2D

@onready var targets: Array
@onready var parent = get_parent()


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# Dude... This is going to be resource intensive. Maybe only check once a second?
	var closest_target
	for target in targets:
		# If there's a closer target, make it the target.
		if !closest_target or parent.global_position.distance_to(closest_target.global_position) < parent.global_position.distance_to(target.global_position):
			closest_target = target
	if !closest_target or !closest_target.has_method('get_global_position'):
		return
	set_target_position(closest_target.global_position)
	set_target_position(closest_target.global_position)
	# Needs DELTA
	parent.velocity = parent.FORCE * parent.global_position.direction_to(get_next_path_position())


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		targets.append(body)


func _on_detection_area_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
