extends Node2D


@onready var game_ui: CanvasLayer = $GameUI
@onready var player_respawn_timer: Timer = $PlayerRespawnTimer
@onready var camera: Camera2D = $Camera
@onready var player = $Player
@onready var navigation_layer: TileMapLayer = $Navigation
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

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
	generate_navigation()

func doLocks():

	var player_pos = player.global_position  # Reference the player's global position
	
	
	# Iterate through all objects in the 'lock_block' group
	for lock in get_tree().get_nodes_in_group("lock_block"):
		if lock.global_position.y > player_pos.y:
			print('locked')
			lock.setLocked(true)  # Lock if below the player
		else:
			lock.setLocked(false)  # Unlock if above the player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):

		doLocks()
		
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
	
	if Input.is_action_just_pressed("reset_room"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()


func startRespawnTimer(diepos):
	#die_sound.play()
	player_die_pos = diepos
	player_respawn_timer.start(1.5)


func generate_navigation():
	var get_rekt = tile_map_layer.get_used_rect()
	for x in range(get_rekt.position.x, get_rekt.position.x + get_rekt.size.x):
		for y in range(get_rekt.position.y, get_rekt.position.y + get_rekt.size.y):
			if tile_map_layer.get_cell_source_id(Vector2(x,y)) != 0:
				navigation_layer.set_cell(Vector2(x,y), 0, Vector2i(0, 0))
