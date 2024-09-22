extends Node

@onready var _1: AudioStreamPlayer2D = $"1"
@onready var _2: AudioStreamPlayer2D = $"2"
@onready var _3: AudioStreamPlayer2D = $"3"
@onready var _4: AudioStreamPlayer2D = $"4"
@onready var _5: AudioStreamPlayer2D = $"5"
@onready var _6: AudioStreamPlayer2D = $"6"
@onready var _7: AudioStreamPlayer2D = $"7"

@export var sound : AudioStreamPlayer2D:
	get():
		match randi_range(1, 7):
			1:
				sound = _1
			2:
				sound = _2
			3:
				sound = _3
			4:
				sound = _4
			5:
				sound = _5
			6:
				sound = _6
			7:
				sound = _7
		_6.play()
		print(sound.pitch_scale)
		return sound
