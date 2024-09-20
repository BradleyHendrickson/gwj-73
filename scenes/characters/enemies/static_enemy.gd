extends CharacterBody2D

@onready var bounce_timer: Timer = $BounceTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_collision_polygon: CollisionPolygon2D = $DetectionArea/DetectionCollisionPolygon
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var sprite_animation_player: AnimationPlayer = $AnimatedSprite2D/SpriteAnimationPlayer
@onready var shot_timer: Timer = $ShotTimer

@export var bullet : PackedScene

@export var new_rotation = 0.0 # in degrees
@export var start_angle = 0.0 # in degrees
@export var end_angle = 0.0 # in degrees
@export var distance = 150
@export var damage: float = 1
@export var shot_delay: float = 0.25

@onready var aim_target
@onready var targets: Array
@onready var bounce_velocity = 500

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
	
	rotation = deg_to_rad(new_rotation)
	
	var points = [Vector2.ZERO]
	var segments = 30
	
	start_angle = deg_to_rad(start_angle)
	end_angle = deg_to_rad(end_angle)
	for seg in range(segments + 1):
		var angle = lerp(start_angle, end_angle, float(seg) / segments)
		points.append(distance * Vector2(cos(angle), -sin(angle)))
	
	detection_collision_polygon.polygon = PackedVector2Array(points)


func _process(delta: float) -> void:
	for target in targets:
		target.hit(damage)
	if aim_target and sprite.rotation != aim_target.get_angle_to(position):
		var rotation_to_target = aim_target.get_angle_to(position) + PI/2
		sprite.rotation = rotation_to_target + PI/2
		shoot(delta, rotation_to_target)

func shoot(delta, rotation_to_target):
	if shot_timer.is_stopped():
		shot_timer.start(shot_delay)
		var newBullet = bullet.instantiate()
		newBullet.collision_mask &= ~(1 << 2)
		newBullet.collision_mask |= (1 << 0)
		newBullet.time = 1.0
		add_child(newBullet)
		newBullet.transform = Transform2D(rotation_to_target, 10 * delta * Vector2(cos(rotation_to_target), sin(rotation_to_target)))


func setShader(value):
	sprite.material.set("shader_param/active", value)


func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		targets.append(body)


func _on_hurt_area_body_exited(body: Node2D) -> void:
	if (targets.has(body)):
		targets.erase(body)

func hit(dmgTaken):
	sprite_animation_player.play("hit")
	health -= dmgTaken


func _on_jump_hit_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("hit") and 0 < body.velocity.y:
		hit(health)
		body.velocity.y = -bounce_velocity


func _on_detection_area_body_entered(body: Node2D) -> void:
	aim_target = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	aim_target = null
