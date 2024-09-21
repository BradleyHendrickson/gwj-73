extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var targets: Array

@export var damage: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()  # Seed the random number generator
	var flippy = randi() % 3 == 0  # Every third spike, set flip_h
	sprite_2d.flip_h = flippy

func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.has_method("insta_death"):
		body.insta_death()


func _on_hurt_area_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
