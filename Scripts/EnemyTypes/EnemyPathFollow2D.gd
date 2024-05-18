extends PathFollow2D


@export var runSpeed = 20

func _process(delta):
	set_progress(get_progress() + runSpeed * delta)
	
	if loop == false and get_progress_ratio() == 1:
		queue_free()
