extends Sprite2D

@onready var animation = $AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (!animation.is_playing()):
		queue_free()
