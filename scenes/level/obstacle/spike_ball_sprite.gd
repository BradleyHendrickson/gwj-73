extends Sprite2D

# Speed of rotation in radians per second
var rotation_speed: float = PI / 4  # 45 degrees per second (PI/4 radians)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Increment the sprite's rotation based on the speed and time since the last frame
	rotation += rotation_speed * delta
