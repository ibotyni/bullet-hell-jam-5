extends Path2D

@export var activation_time : float = 5
@export var deactivation_time : float = 10
@export var isSingle: bool = false
@export var subject: PackedScene
@export var isCycle: bool = false
@export var spawnTime: float = 1.0

var time_elapsed: float = 0.0
var is_active: bool = false
var timer: float = 0.0

func _ready():
	if isSingle and subject != null:
		add_child(subject.instantiate())
	else:
		is_active = false 

func _process(delta):
	if !isSingle: 
		time_elapsed += delta
	
		if !is_active and time_elapsed >= activation_time:
			is_active = true
			time_elapsed = 0.0 

		if is_active and time_elapsed >= deactivation_time:
			is_active = false
			time_elapsed = 0.0

			if isCycle:
				is_active = true 

	if is_active:
		timer += delta
		if timer > spawnTime:
			if subject != null:
				add_child(subject.instantiate())
			timer = 0
