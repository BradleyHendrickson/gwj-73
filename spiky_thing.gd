extends Node2D

@onready var targets: Array

@export var damage: float = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for target in targets:
		target.hit(damage)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		targets.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
