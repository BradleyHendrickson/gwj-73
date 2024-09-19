extends Node2D

@export var smokeParticle : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func smoke(amount):
	#if smokeParticle:
		#for i in amount:
			#var x = smokeParticle.instantiate()
			#get_tree().root.add_child(x)
			#x.position = get_parent().position
			#x.moveRand()
