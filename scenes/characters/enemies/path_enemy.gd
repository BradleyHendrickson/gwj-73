extends CharacterBody2D

@onready var bounce_timer: Timer = $BounceTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray = $"RayCast2D"
@onready var smoke_generator: Node2D = $SmokeGenerator

@onready var targets: Array

@export var INITIAL_ANGLE = 0.0 # in degrees
@export var FORCE = 50
@onready var sprite_animation_player: AnimationPlayer = $AnimatedSprite2D/SpriteAnimationPlayer
@export var damage: float = 1

@export var move_to := Vector2(0, -128): 
	set(value):
		move_to = value
		position += value
	get():
		return move_to

@export var health: int = 3: 
	set(value):
		health = value
		if health <= 0:
			queue_free()
			smoke_generator.smoke(3)
	get():
		return health


func _ready() -> void:
	setShader(false)
	var radAngle = INITIAL_ANGLE * PI / 180
	ray.global_rotation = radAngle
	velocity = Vector2(FORCE * cos(radAngle), FORCE * sin(radAngle))

func setShader(value):
	animated_sprite_2d.material.set("shader_param/active", value);

func _process(delta: float) -> void:
	if velocity.x > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	if ray.is_colliding() and bounce_timer.is_stopped():
		bounce_timer.start(0.2)
		ray.target_position = -ray.target_position
		velocity = -1 * velocity
	else:
		move_and_slide()
		
	for target in targets:
		target.hit(damage)


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		targets.append(body)


func _on_hurt_area_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)

func hit(dmgTaken):
	sprite_animation_player.play("hit")
	health -= dmgTaken
