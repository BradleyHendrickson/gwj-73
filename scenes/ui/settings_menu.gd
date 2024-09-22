extends Control

@onready var input_key = ""
@onready var jump_binding: Button = $TabBar/JumpBinding
@onready var shoot_binding: Button = $TabBar/ShootBinding
@onready var left_binding: Button = $TabBar/LeftBinding
@onready var right_binding: Button = $TabBar/RightBinding
@onready var up_binding: Button = $TabBar/UpBinding
@onready var down_binding: Button = $TabBar/DownBinding


func _input(event: InputEvent) -> void:
	if event.as_text() == "Escape":
		input_key = ""
	if "" != input_key and event.is_pressed():
		InputMap.action_erase_events(input_key)
		InputMap.action_add_event(input_key, event)
		print(event.as_text())
		match input_key:
			"input_jump":
				jump_binding.text = "Jump - " + event.as_text()
			"input_shoot":
				shoot_binding.text = "Shoot - " + event.as_text()
			"input_left":
				shoot_binding.text = "Left - " + event.as_text()
			"input_right":
				shoot_binding.text = "Right - " + event.as_text()
			"input_up":
				shoot_binding.text = "Up - " + event.as_text()
			"input_down":
				shoot_binding.text = "Down - " + event.as_text()
		
		input_key = ""


func _on_jump_binding_pressed() -> void:
	input_key = "input_jump"


func _on_shoot_binding_pressed() -> void:
	input_key = "input_shoot"


func _on_left_binding_pressed() -> void:
	input_key = "input_left"


func _on_right_binding_pressed() -> void:
	input_key = "input_right"


func _on_up_binding_pressed() -> void:
	input_key = "input_up"


func _on_down_binding_pressed() -> void:
	input_key = "input_down"


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
