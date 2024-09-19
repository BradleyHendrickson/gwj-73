extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

@onready var targets: Array

func _ready() -> void:
	setShader(!get_parent().destination_zone)


func _process(delta: float) -> void:
	if get_parent().destination_zone:
		for target in targets:
			target.teleport(get_parent().destination_zone.position)


func setShader(value):
	sprite.material.set("shader_param/active", value)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("teleport"):
		targets.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
