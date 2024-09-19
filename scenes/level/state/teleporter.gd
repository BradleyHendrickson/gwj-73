extends Node2D

@export var destination_zone : Node2D
@onready var targets: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for target in targets:
		target.teleport(destination_zone.position)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("teleport"):
		targets.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
