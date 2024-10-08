extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var ACTIVATED: bool = false


func _ready() -> void:
	setShader(!ACTIVATED)


func setShader(value):
	sprite.material.set("shader_param/active", value)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !ACTIVATED:
		get_parent().destination_zone = self
		ACTIVATED = true
		setShader(false)
