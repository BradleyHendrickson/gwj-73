extends CharacterBody2D

# BASIC MOVEMENT VARAIABLES ---------------- #
var face_direction := 1
var x_dir := 1

@export var starBullet : PackedScene
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var animated_sprite_2d = $Sprite/AnimatedSprite2D
@onready var shot_timer: Timer = $ShotTimer
@onready var sprite: Node2D = $Sprite
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer

@export var max_speed: float = 150
@export var acceleration: float = 1100
@export var turning_acceleration : float = 2000
@export var deceleration: float = 1900
# ------------------------------------------ #

# GRAVITY ----- #
@export var gravity_acceleration : float = 1100
@export var gravity_max : float = 500
# ------------- #

# JUMP VARAIABLES ------------------- #
@export var jump_force : float = 400
@export var jump_cut : float = 0.5
@export var jump_gravity_max : float = 250
@export var jump_hang_treshold : float = 2.0
@export var jump_hang_gravity_mult : float = 0.05
# Timers
@export var jump_coyote : float = 0.08
@export var jump_buffer : float = 0.1

var jump_coyote_timer : float = 0
var jump_buffer_timer : float = 0
var is_jumping := false
var knockback_value := Vector2(0, 0)
# ----------------------------------- #

#creates a dictionary of all current inputs at the current state
func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("input_right")) - int(Input.is_action_pressed("input_left")),
		"y": int(Input.is_action_pressed("input_down")) - int(Input.is_action_pressed("input_up")),
		"just_jump": Input.is_action_just_pressed("input_jump") == true,
		"jump": Input.is_action_pressed("input_jump") == true,
		"released_jump": Input.is_action_just_released("input_jump") == true,
		"shoot" : Input.is_action_pressed("input_shoot") == true,
		"duck" : Input.is_action_just_pressed("input_down")
	}

func _physics_process(delta: float) -> void:
	x_movement(delta)
	jump_logic(delta)
	apply_gravity(delta)
	animations(delta)
	move_and_slide()
	shoot(delta)
	
	if Input.is_action_just_pressed("reset_room"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()


func animations(delta):
	animated_sprite_2d.play("default")
	animated_sprite_2d.speed_scale = (abs(velocity.x)/max_speed) * 1.2
	
	if !is_on_floor():
		animated_sprite_2d.frame = 1
	elif abs(velocity.x) <= 0.1*delta:
		animated_sprite_2d.frame = 0

func shoot(delta):
	if get_input()["shoot"] and shot_timer.is_stopped():
		sprite.shootAnimation()
		shot_timer.start(0.25)
		var newBullet = starBullet.instantiate()
		get_tree().root.add_child(newBullet)
		var aimVector = Vector2(0,-1)
		newBullet.transform = Transform2D( aimVector.angle() , position + Vector2(0,-10))


func x_movement(delta: float) -> void:
	x_dir = get_input()["x"]
	
	# Stop if we're not doing movement inputs.
	if x_dir == 0: 
		velocity.x = Vector2(velocity.x, 0).move_toward(Vector2(0,0), deceleration * delta).x
		return
	
	# If we are doing movement inputs and above max speed, don't accelerate nor decelerate
	# Except if we are turning
	# (This keeps our momentum gained from outside or slopes)
	if abs(velocity.x) >= max_speed and sign(velocity.x) == x_dir:
		return
	
	# Are we turning?
	# Deciding between acceleration and turn_acceleration
	var accel_rate : float = acceleration if sign(velocity.x) == x_dir else turning_acceleration
	
	# Accelerate
	velocity.x += x_dir * accel_rate * delta
	set_direction(x_dir) # This is purely for visuals


func set_direction(hor_direction) -> void:
	if hor_direction == 0 or hor_direction * face_direction != -1:
		return
	
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	face_direction = hor_direction


func jump_logic(_delta: float) -> void:
	# Reset our jump requirements
	if is_on_floor():
		jump_coyote_timer = jump_coyote
		is_jumping = false
	if get_input()["just_jump"]:
		jump_buffer_timer = jump_buffer
	
	# Jump if grounded, there is jump input, and we aren't jumping already
	if jump_coyote_timer > 0 and jump_buffer_timer > 0 and not is_jumping:
		is_jumping = true
		jump_coyote_timer = 0
		jump_buffer_timer = 0
		# If falling, account for that lost speed
		if velocity.y > 0:
			velocity.y -= velocity.y
		
		velocity.y = -jump_force
	
	# We're not actually interested in checking if the player is holding the jump button
#	if get_input()["jump"]:pass
	
	# Cut the velocity if let go of jump. This means our jumpheight is varaiable
	# This should only happen when moving upwards, as doing this while falling would lead to
	# The ability to studder our player mid falling
	if get_input()["released_jump"] and velocity.y < 0:
		velocity.y -= (jump_cut * velocity.y)
	
	# This way we won't start slowly descending / floating once hit a ceiling
	# The value added to the treshold is arbritary,
	# But it solves a problem where jumping into 
	if is_on_ceiling(): velocity.y = jump_hang_treshold + 100.0


func apply_gravity(delta: float) -> void:
	var applied_gravity : float = 0
	
	# No gravity if we are grounded
	if jump_coyote_timer > 0:
		return
	
	# Normal gravity limit
	if velocity.y <= gravity_max:
		applied_gravity = gravity_acceleration * delta
	
	# If moving upwards while jumping, the limit is jump_gravity_max to achieve lower gravity
	if (is_jumping and velocity.y < 0) and velocity.y > jump_gravity_max:
		applied_gravity = 0
	
	# Lower the gravity at the peak of our jump (where velocity is the smallest)
	if is_jumping and abs(velocity.y) < jump_hang_treshold:
		applied_gravity *= jump_hang_gravity_mult
	
	velocity.y += applied_gravity
