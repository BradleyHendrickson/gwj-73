extends Area2D

@export var friction = 1000
@export var speed = 400
@export var damage = 1

var damagable_targets: Array
@onready var smoke_generator: Node2D = $SmokeGenerator

@onready var timer = $Timer
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var hitEffect : PackedScene


func longTime():
	timer.start(2)

func destroy():
	queue_free()

func die():
	var f = hitEffect.instantiate()
	get_tree().root.add_child(f)
	f.transform = Transform2D((randi() % 4) * PI / 2, position) # BLACK MAGIC
	
	smoke_generator.smoke(3)
	
	queue_free()
	pass
	
	

func _physics_process(delta):
	if timer.is_stopped():
		die()
		
	animated_sprite_2d.play("default")
	position += transform.x * speed * delta
	for t in damagable_targets:
		t.hit(damage)

func _on_body_entered(body):
	if body.has_method("hit"):
		damagable_targets.append(body)
	die()

func _on_body_exited(body):
	if (damagable_targets.has(body)):
		damagable_targets.erase(body)
