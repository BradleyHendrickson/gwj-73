extends CharacterBody2D

@onready var ray = $"RayCast2D"
@onready var INITIAL_ANGLE = 0.2 # in radians
@onready var FORCE = 100


@export var move_to := Vector2(0, -128): 
	set(value):
		move_to = value
		position += value
	get():
		return move_to


func _ready() -> void:
	ray.global_rotation = INITIAL_ANGLE
	velocity = Vector2(FORCE * cos(INITIAL_ANGLE), FORCE * sin(INITIAL_ANGLE))


func _process(delta: float) -> void:
	print(velocity)
	if ray.is_colliding():
		ray.target_position = -ray.target_position
		print(velocity)
		velocity = -1 * velocity
		print(velocity)
	else:
		move_and_slide()
