
extends Node2D
## Script controlling a moving platform (or spike, or anything else you might want to move).
##
## Updating the move_to varaiable works in editor to speed up level design
## This code can work with moving spikes and alike, all you need is swap out the reference to MovedObject.
## And also Make the child an Area2D that reacts to the player collisions.
@export var enemies: Array[CharacterBody2D]

@export var move_to := Vector2(0, -128) : set = set_move_to
func set_move_to(new_value: Vector2) -> void:
	move_to = new_value
	if get_children() != []:
		for child in get_children():
			child.position = move_to

@export var speed: int = 64 
@export var delay: float = 0.4 ## delay (sec) before moving to move_to
@export var line_width : float = 4.0

func _ready() -> void:

	if enemies_exist():
		speed = 0

	set_move_to(move_to)
	#set_process(false)
	for child in get_children():
		start_tween(child)

func _process(_delta: float) -> void:

	if !enemies_exist() and speed == 0:
		speed = 20
		set_move_to(move_to)
		for child in get_children():
			start_tween(child)
	
	queue_redraw()

func _draw() -> void:
	if line_width == 0: return
	draw_line(move_to, -move_to, Color("#141013"), line_width)

func start_tween(Moved) -> void:
	Moved.position = move_to
	if speed == 0: return
	var time = move_to.length() / float(speed)
	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD) # warning-ignore:return_value_discarded
	tween.tween_property(Moved, "position", -move_to, time).set_delay(delay) # warning-ignore:return_value_discarded
	tween.tween_property(Moved, "position", move_to, time).set_delay(delay) # warning-ignore:return_value_discarded
	tween.set_loops() # warning-ignore:return_value_discarded


func enemies_exist() -> bool:
	for enemy in enemies:
		if is_instance_valid(enemy):
			return true # If any enemy exists, return true
	return false # If no enemies exist, return false
