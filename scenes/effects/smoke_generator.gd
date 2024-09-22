extends Node2D

@export var smokeParticle : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func smoke(amount):
	# Use call_deferred to handle the smoke instantiation after the current processing
	call_deferred("_spawn_smoke", amount, get_parent().position )

func smoke_at_position(amount, pos):
	# Use call_deferred to handle the smoke instantiation after the current processing
	call_deferred("_spawn_smoke", amount, pos)

func _spawn_smoke(amount, pos):
	for i in range(amount):
		var x = smokeParticle.instantiate()
		get_tree().root.add_child(x)
		x.position = pos
		x.moveRand()
