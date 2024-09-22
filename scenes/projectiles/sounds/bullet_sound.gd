extends Node

@onready var _1: AudioStreamPlayer2D = $"1"
@onready var _2: AudioStreamPlayer2D = $"2"
@onready var _3: AudioStreamPlayer2D = $"3"
@onready var _4: AudioStreamPlayer2D = $"4"
@onready var _5: AudioStreamPlayer2D = $"5"

@export var sound : AudioStreamPlayer2D:
	get():
		match randi_range(1, 5):
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
		return sound
