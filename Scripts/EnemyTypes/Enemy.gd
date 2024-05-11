class_name Enemy extends CharacterBody2D

@export var speed = 50.0  # Adjust the speed as needed (lower value for slower movement)


func _physics_process(delta):
	global_position.y += speed * delta



func _on_visible_on_screen_notifier_2d_screen_exited():
	pass # Replace with function body.

func die():
	queue_free()
