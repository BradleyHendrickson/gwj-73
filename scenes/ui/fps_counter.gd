extends Label

func _process(delta):
	# Update the label's text with the current FPS
	text = "FPS: " + str(Engine.get_frames_per_second())
