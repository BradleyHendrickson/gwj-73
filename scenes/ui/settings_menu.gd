extends Control

@onready var input_key = ""
@onready var jump_binding: Button = $TabBar/JumpBinding
@onready var shoot_binding: Button = $TabBar/ShootBinding


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#jump_binding.connect("pressed", _on_jump_binding_pressed)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
		

func _input(event: InputEvent) -> void:
	if "" != input_key and event.is_pressed():
		InputMap.action_add_event(input_key, event)
		print(event.as_text())
		match input_key:
			"input_jump":
				jump_binding.text = "Jump - " + event.as_text()
			"input_jump":
				shoot_binding.text = "Shoot - " + event.as_text()
		
		input_key = ""


func _on_up_binding_pressed() -> void:
	input_key = "move_up"


func _on_jump_binding_pressed(emitter) -> void:
	input_key = "input_jump"


func _on_shoot_binding_pressed() -> void:
	input_key = "input_shoot"
