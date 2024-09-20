extends CharacterBody2D

@onready var bounce_timer: Timer = $BounceTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var right_ray: RayCast2D = $"RightRay"
@onready var up_ray: RayCast2D = $"UpRay"
@onready var down_right_ray: RayCast2D = $DownRightRay
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var sprite_animation_player: AnimationPlayer = $AnimatedSprite2D/SpriteAnimationPlayer

@export var INITIAL_ANGLE = 0.0 # in degrees
@export var FORCE = 50
@export var damage: float = 1

@onready var hurt_targets: Array
@onready var aim_targets: Array
@onready var bounce_velocity = 300

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
			smoke_generator.smoke(6)
	get():
		return health


func _ready() -> void:
	setShader(false)
	velocity = FORCE * Vector2(0,-1)

func _process(delta: float) -> void:
	if !right_ray.is_colliding() and down_right_ray.is_colliding():
		rotate(PI/2)
		velocity = velocity.rotated(PI/2)
	elif up_ray.is_colliding():
		rotate(-PI/2)
		velocity = velocity.rotated(-PI/2)
	move_and_slide()
	
	for target in hurt_targets:
		target.hit(damage)


func setShader(value):
	animated_sprite_2d.material.set("shader_param/active", value)


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		hurt_targets.append(body)


func _on_hurt_area_body_exited(body: Node2D) -> void:
	if (hurt_targets.has(body)):
		hurt_targets.erase(body)

func hit(dmgTaken):
	sprite_animation_player.play("hit")
	health -= dmgTaken


func _on_jump_hit_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("hit") and 0 < body.velocity.y:
		hit(health)
		body.velocity.y = -bounce_velocity


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		aim_targets.append(body)


func _on_detection_area_body_exited(body: Node2D) -> void:
	if (aim_targets.has(body)):
		aim_targets.erase(body)
