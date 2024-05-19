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

@export var is_boss := false  # Flag to indicate if this path is for a boss
var boss_spawned := false     # Flag to track if the boss has already been spawned
var game_manager = null

func _ready():
	if isSingle and subject != null:
		add_child(subject.instantiate())
	else:
		is_active = false 

func _process(delta):
	if !is_boss:  # Only do regular spawning if NOT a boss path
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


func _on_level_is_boss_signal():
	if is_boss:  # Check if this path is meant for a boss
		if not boss_spawned:  # Make sure the boss hasn't already spawned
			if subject != null:  # Safety check for PackedScene
				add_child(subject.instantiate())  # Spawn the boss
				boss_spawned = true  # Mark the boss as spawned
	else:  # This path is not for a boss
		queue_free()  # Remove this path during the boss battle
