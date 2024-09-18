extends CanvasLayer

@onready var h_box_container: HBoxContainer = $GameUIContainer/HBoxContainer

@export var heart : PackedScene
@export var half_heart : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setHealth(amount):
	for n in h_box_container.get_children():
		h_box_container.remove_child(n)
		n.queue_free()
		
	var hearts = float(amount/2.0)
	while hearts > 0:
		if hearts >= 1:
			var b = heart.instantiate()
			h_box_container.add_child(b)
			hearts -= 1
		elif hearts > 0:
			var b = half_heart.instantiate()
			h_box_container.add_child(b)
			hearts = 0
