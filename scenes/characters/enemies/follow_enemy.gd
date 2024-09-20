extends CharacterBody2D

@onready var bounce_timer: Timer = $BounceTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var sprite_animation_player: AnimationPlayer = $AnimatedSprite2D/SpriteAnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var follow_navigation: NavigationAgent2D = $FollowNavigation
@onready var follow_timer: Timer = $FollowTimer

@export var resting = false
@export var FORCE = 65
@export var damage: float = 1
@export var move_to := Vector2(0, -128):
	set(value):
		move_to = value
		position += value
	get():
		return move_to
@export var health: int = 2: 
	set(value):
		health = value
		if health <= 0:
			queue_free()
			smoke_generator.smoke(6)
	get():
		return health

@onready var targets: Array
@export var bounce_velocity = 300

func wake():
	resting = false
	animation_player.play("hover")
	animated_sprite_2d.play("default")
	follow_timer.start(0.2)
	sprite_animation_player.play("RESET")
	animation_player.play("RESET")

func _ready() -> void:
	if resting:
		animation_player.play("resting")
		animated_sprite_2d.play("resting")
	
	setShader(false)

func _process(delta: float) -> void:
	
	if follow_navigation and !resting:
		if follow_timer.is_stopped():
			follow_navigation.follow(delta)
		else:
			velocity.y = 60
	
	if 0 < velocity.x:
		animated_sprite_2d.flip_h = true
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = false
	move_and_slide()
	
	for target in targets:
		target.hit(damage)


func setShader(value):
	animated_sprite_2d.material.set("shader_param/active", value)


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


func _on_wake_area_body_entered(body: Node2D) -> void:
	if resting:
		wake()
