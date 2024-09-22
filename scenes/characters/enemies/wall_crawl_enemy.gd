extends CharacterBody2D

var GRID_SIZE = 16

@onready var bounce_timer: Timer = $BounceTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var right_ray: RayCast2D = $RightRay
@onready var forward_ray: RayCast2D = $ForwardRay
@onready var smoke_generator: Node2D = $SmokeGenerator
@onready var sprite_animation_player: AnimationPlayer = $AnimatedSprite2D/SpriteAnimationPlayer

@export var segment_count: int = 5  # Number of segments to create
@export var FORCE = 50
@export var damage: float = 1

var next_segment: CharacterBody2D = null

@onready var hurt_targets: Array
@onready var aim_targets: Array
@onready var bounce_velocity = 300

var move_from := Vector2()
@onready var move_to := position:
	set(value):
		move_from = move_to
		move_to = value
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
	#Engine.time_scale = 0.05
	setShader(false)
	velocity = FORCE * Vector2(0,-1)
	if segment_count > 0:
		# Generate the next segment upon initialization
		generate_next_segment(segment_count)

func generate_next_segment(segment_count: int) -> void:
	print('running new segment')
	# Create a new segment (duplicate of the current one)
	var new_segment = self.duplicate()
	# Initialize properties BEFORE adding to the scene
	new_segment.segment_count = segment_count - 1
	new_segment.move_to = position  # Set its initial position
	new_segment.next_segment = self  # Link the new segment to follow this one
	# Add the new segment to the scene AFTER setting properties
	get_tree().root.add_child(new_segment)
	# Ensure the new segment processes
	new_segment.set_process(true)
	# Recursively generate the next segment
	#new_segment.generate_next_segment(segment_count - 1)

func movement(delta: float) -> void:
	if next_segment != null:
		# Check the distance to the previous segment's move_from position
		var distance_to_next = position.distance_to(next_segment.move_from)
		# If the distance is greater than a full grid square, move faster to catch up
		var speed_factor = 1.5 if distance_to_next > GRID_SIZE else 1.0
		# Snap if close enough to the next segment's last position
		if distance_to_next <= (velocity.length() * delta):
			position = next_segment.move_from
		# Only start moving when the previous segment has completed its move
		if position == move_to:
			# Set the new move_to based on the previous segment's last position
			move_to = next_segment.move_from
		else:
			# Move towards the move_to position with speed adjustment
			position = position.move_toward(move_to, velocity.length() * delta * speed_factor)
		# Rotate to face the movement direction like the head
		rotation = position.angle_to(move_to)
	else:
		# This is the head, handle movement as before
		if (move_to - position).length() < (velocity.length() * delta):
			position = move_to  # Snap to the target position
			# Standard movement logic for the head
			if right_ray.is_colliding():
				if !forward_ray.is_colliding():
					move_to = position + velocity.normalized() * GRID_SIZE  # Move forward
				else:
					rotate(-PI / 2)
					velocity = velocity.rotated(-PI / 2)
					move_to = position + velocity.normalized() * GRID_SIZE  # Turn left
			else:
				rotate(PI / 2)
				velocity = velocity.rotated(PI / 2)
				move_to = position + velocity.normalized() * GRID_SIZE  # Turn right
		else:
			# Continue moving toward the next target
			position = position.move_toward(move_to, velocity.length() * delta)
	# Update sprite based on whether this segment is a head or body
	update_sprite()

# Function to update the sprite dynamically
func update_sprite() -> void:
	if next_segment == null:
		animated_sprite_2d.play("head")  # Play the head animation or sprite
	else:
		animated_sprite_2d.play("body")  # Play the body segment animation or sprite

# Ensure that each segment waits until its parent segment has left a position behind
func initialize_segment_position():
	if next_segment != null:
		# Start at the previous segment's current position
		position = next_segment.move_from
	else:
		# If it's the head, set its initial position
		move_to = position

func _process(delta: float) -> void:
	movement(delta)
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

# When a segment is destroyed, the next one becomes the new head
func destroy_segment() -> void:
	if next_segment != null:
		next_segment.next_segment = null

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		aim_targets.append(body)


func _on_detection_area_body_exited(body: Node2D) -> void:
	if (aim_targets.has(body)):
		aim_targets.erase(body)
