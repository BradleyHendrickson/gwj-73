extends Node

@onready var _5: AudioStreamPlayer2D = $"5"
@onready var _6: AudioStreamPlayer2D = $"6"
@onready var _7: AudioStreamPlayer2D = $"7"

@export var sound : AudioStreamPlayer2D:
	get():
		match randi_range(5, 7):
			5:
				sound = _5
			6:
				sound = _6
			7:
				sound = _7
		return sound
