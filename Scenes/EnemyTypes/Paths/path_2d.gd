extends Path2D

@export var speed = 25.0  # Speed for objects to follow the path

func _physics_process(delta):
	for child in get_children():
		if child is PathFollow2D:
			child.progress_ratio += speed * delta
