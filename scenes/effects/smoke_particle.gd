extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FRICTION = 100
@onready var animated_sprite_2d = $AnimatedSprite2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if velocity.length() == 0:
		moveRand()

func moveUp():
	var mag = randf_range(50,180)
	var dir= deg_to_rad(randf_range(0,180)+180)
	velocity = Vector2(cos(dir), sin(dir))* mag
	
	
	
func moveDir(direction):
	var mag = randf_range(50,180)
	var dir= deg_to_rad(rad_to_deg(direction))
	velocity = Vector2(cos(dir), sin(dir))* mag
	
func moveRand():
	var mag = randf_range(50,180)
	var dir= deg_to_rad(randf_range(0,360))
	velocity = Vector2(cos(dir), sin(dir))* mag

func _process(delta: float) -> void:
	if !animated_sprite_2d.is_playing():
		queue_free()

func _physics_process(delta):

		
	# Apply friction
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
	
	move_and_slide()
