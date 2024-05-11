class_name Enemy extends Area2D

signal defeated

@export var speed = 50.0
@export var hp = 1
@export var points = 100 

func _physics_process(delta):
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Enemy: Exited screen")

func die():
	queue_free()

func take_damage(amount):
	hp -= amount
	if hp <= 0: 
		defeated.emit(points)
		die()
