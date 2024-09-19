extends Control

# Reference to the label node
@onready var fps_label = $Label

func _process(delta):
	# Update the label's text with the current FPS
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
