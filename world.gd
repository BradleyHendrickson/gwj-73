extends Node2D


@onready var game_ui: CanvasLayer = $GameUI
@onready var death_camera: Camera2D = $DeathCamera
@onready var player_respawn_timer: Timer = $PlayerRespawnTimer
@onready var camera: Camera2D = $Camera

@export var follow_smoothing = 7	
@export var playerObject : PackedScene
@export var player_die_pos : Vector2
@export var health = 10
@onready var player = $Player

var target_camera_position = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func startRespawnTimer(diepos):
	#die_sound.play()
	player_die_pos = diepos
	player_respawn_timer.start(1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if is_instance_valid(player):
		target_camera_position = player.global_position
	else:
		if player_respawn_timer.is_stopped():
			var p = playerObject.instantiate()
			add_child(p)
			player = p
			health = 10
			p.position = Vector2(0, 56)
	
	#target_position_clamped = target_position.clamped(level_bounds)
	camera.global_position = camera.global_position.lerp(target_camera_position, delta * follow_smoothing)
	
	game_ui.setHealth(health)
	
	pass
