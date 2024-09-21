extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var targets: Array

@export var damage: float = 2

func _process(delta: float) -> void:
	for target in targets:
		target.hit(damage)

func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		targets.append(body)
	if body.has_method("knockback"):
		body.knockback(Vector2(1,0.1)) #small positive y value reduces friction with ground

func _on_hurt_area_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
