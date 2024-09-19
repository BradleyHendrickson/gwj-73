extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var targets: Array

@export var damage: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()  # Seed the random number generator
	var flippy = randi() % 2 == 0  # Randomly set flip_h
	sprite_2d.flip_h = flippy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for target in targets:
		target.hit(damage)


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		targets.append(body)


func _on_hurt_area_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)
