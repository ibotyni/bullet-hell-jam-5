extends PathFollow2D

@export var runSpeed = 20
@export var isLooping = false # New property to control looping

func _ready():
	# Set loop based on isLooping
	loop = isLooping


func _process(delta):
	set_progress(get_progress() + runSpeed * delta)
	if !isLooping: 
		if get_progress_ratio() == 1: # Reached the end of the path
			queue_free()
