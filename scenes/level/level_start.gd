extends Node2D

@onready var closed_door: TileMapLayer = $ClosedDoor
@onready var open_door: TileMapLayer = $OpenDoor
@onready var timer: Timer = $Timer

var time_left = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_door.modulate.a = 1.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !timer.is_stopped():
		if 0.01 < time_left - timer.time_left:
			open_door.modulate.a -= 0.05
			time_left = timer.time_left


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if timer.is_stopped():
		timer.start(1)
		time_left = timer.time_left


func _on_next_level_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_tree().change_scene_to_file("res://scenes/level/level_main.tscn")
