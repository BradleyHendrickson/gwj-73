extends Node2D
# This is a hacky way of doing animation
# I do not advise you using this in real projects
# Instead learn how to use a STATE MACHINE
# https://www.youtube.com/results?search_query=godot+state+machine
# Choose a video of your liking

@export var player_path : NodePath
@onready var Player := get_node(player_path)
@onready var Animator := $AnimationPlayer
@onready var sprite_animation_player: AnimationPlayer = $AnimatedSprite2D/SpriteAnimationPlayer

var previous_frame_velocity := Vector2(0,0)

# Avoid errors
func _ready() -> void:
	if Player == null:
		set_process(false)

func shootAnimation():
	Animator.play("Shoot")
	
func hitAnimation():
	sprite_animation_player.play("hit")

func hitAnimationIsPlaying():
	return sprite_animation_player.is_playing()

func _process(_delta: float) -> void:
	if previous_frame_velocity.y >= 0 and Player.velocity.y < 0:
		Animator.play("Jump")
	elif previous_frame_velocity.y > 0 and Player.is_on_floor():
		Animator.play("Land")

	# It's important that this is the last thing done
	previous_frame_velocity = Player.velocity
