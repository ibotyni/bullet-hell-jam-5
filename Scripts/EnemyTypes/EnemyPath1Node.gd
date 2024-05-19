extends Path2D

@export var activation_time : float = 5 
@export var deactivation_time : float = 10

@export var isSingle: bool = false   # New property to control single spawn
@export var subject: PackedScene

var timer = 0
@export var spawnTime = 1

@onready var activationTime: Timer = $EnemyPath1ActivationTimer
@onready var deactivationTime: Timer = $EnemyPath1DeactivationTimer

@export var isCycle: bool = false


func _ready():
	if isSingle:
		# Spawn a single subject immediately
		if subject != null:
			var new_subject = subject.instantiate()
			add_child(new_subject)
	else:
		# Normal initialization for multiple spawns
		set_process(false)  
		activationTime.wait_time = activation_time  
		deactivationTime.wait_time = deactivation_time

func _process(delta):
	if !isSingle:  # Only run spawning logic if not in single spawn mode
		timer = timer + delta
		if timer > spawnTime:
			var new_subject = subject.instantiate()
			add_child(new_subject)
			timer = 0


func _on_enemy_path_1_activation_timer_timeout():
	if !isSingle:  # Only run if not in single spawn mode
		set_process(true)
		deactivationTime.start() 


func _on_enemy_path_1_deactivation_timer_timeout():
	if !isSingle:  # Only run if not in single spawn mode
		set_process(false)  
		if isCycle:
			activationTime.start()
