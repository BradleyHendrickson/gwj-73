extends Node2D


@onready var game_ui: CanvasLayer = $GameUI
@onready var player_respawn_timer: Timer = $PlayerRespawnTimer
@onready var camera: Camera2D = $Camera
@onready var player = $Player

@export var follow_smoothing = 7
@export var playerObject : PackedScene
@export var player_die_pos : Vector2
@export var health: int = 10:
	set(value):
		health = value
		game_ui.setHealth(health)
	get():
		return health
@export var destination_zone : Node2D:
	set(value):
		destination_zone = value
		if $"Teleporter":
			$"Teleporter".setShader(false)
	get():
		return destination_zone

var target_camera_position = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_ui.setHealth(health)


func startRespawnTimer(diepos):
	#die_sound.play()
	player_die_pos = diepos
	player_respawn_timer.start(1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):
		# Bias the camera towards the horizontal center of the screen
		var screen_center_x = 0.0
		target_camera_position.x = lerp(player.global_position.x, screen_center_x, 0.1) # Horizontal bias factor
		target_camera_position.y = player.global_position.y # Keep vertical alignment with the player
	else:
		if player_respawn_timer.is_stopped():
			var p = playerObject.instantiate()
			add_child(p)
			player = p
			health = 10
			p.position = Vector2(0, 56)
	
	# Smoothly move the camera towards the biased target position
	camera.global_position = camera.global_position.lerp(target_camera_position, delta * follow_smoothing)

	
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
