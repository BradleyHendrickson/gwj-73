extends CharacterBody2D

@onready var bounce_timer: Timer = $BounceTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_collision_polygon: CollisionPolygon2D = $DetectionArea/DetectionCollisionPolygon
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var sprite_animation_player: AnimationPlayer = $AnimatedSprite2D/SpriteAnimationPlayer
@onready var shot_timer: Timer = $ShotTimer
@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer

@export var bullet : PackedScene

@export var start_angle = 180	 # in degrees
@export var end_angle = 360 # in degrees
@export var distance = 200	
@export var bullet_count = 6
@export var my_shot_offset = 20
@export var damage: float = 1
@export var shot_delay: float = 0.75		
@export var shot_life: float = 1.2

@onready var aim_target
@onready var targets: Array
@onready var bounce_velocity = 500

var myRotation = 0.0
var shot_offset = 0

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
	
	var points = [Vector2.ZERO]
	var segments = 30
	
	start_angle = deg_to_rad(start_angle)
	end_angle = deg_to_rad(end_angle)
	for seg in range(segments + 1):
		var angle = lerp(start_angle, end_angle, float(seg) / segments)
		points.append(distance * Vector2(cos(angle), -sin(angle)))
	
	detection_collision_polygon.polygon = PackedVector2Array(points)


func _process(delta: float) -> void:
	# Apply damage to all targets
	for target in targets:
		target.hit(damage)

	# Check if there is an aim target
	if aim_target:
		# Get the angle to the aim target
		var rotation_to_target = self.get_angle_to(aim_target.position)
		
		
		# Shoot towards the aim target
		shoot(delta, rotation_to_target)



func shoot(delta, rotation_to_target):
	if shot_timer.is_stopped():
		animation_player.stop()
		animation_player.play("shoot")
		shot_timer.start(shot_delay)

		# Increment the shot_offset by 5 degrees (converted to radians)
		shot_offset += deg_to_rad(my_shot_offset)

		# Apply the shot_offset to the start_angle
		var adjusted_start_angle = start_angle + shot_offset

		var angle_step = (end_angle - start_angle) / (bullet_count - 1)

		for i in range(bullet_count):
			var current_angle = adjusted_start_angle + i * angle_step

			var newBullet = bullet.instantiate()
			newBullet.time = shot_life

			# Calculate the bullet's position based on the sprite's position and current angle
			var bullet_position = position + Vector2(cos(current_angle), sin(current_angle)) * 10

			# Set the position and rotation of the bullet
			newBullet.transform = Transform2D(current_angle, bullet_position)

			# Add the bullet to the scene
			get_tree().root.add_child(newBullet)



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
