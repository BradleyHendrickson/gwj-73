extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()  # Seed the random number generator
	var flippy = randi() % 2 == 0  # Randomly set flip_h
	print(flippy)
	sprite_2d.flip_h = flippy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
