extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level/level_1.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")
