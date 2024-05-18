extends Path2D

@export var activation_time : float = 5 # Default to 5 seconds if not set in Inspector
@export var deactivation_time : float = 10

var timer = 0
@export var spawnTime = 1

@export var follower: PackedScene

@onready var activationTime: Timer = $EnemyPath1ActivationTimer
@onready var deactivationTime: Timer = $EnemyPath1DeactivationTimer

@export var isCycle: bool = false


func _ready():
	set_process(false)  # Initial state: no spawning

	activationTime.wait_time = activation_time  
	deactivationTime.wait_time = deactivation_time


func _process(delta):
	timer = timer + delta
	if (timer > spawnTime):
		var new_follower = follower.instantiate()
		add_child(new_follower)
		timer = 0


func _on_enemy_path_1_activation_timer_timeout():
	set_process(true) 
	deactivationTime.start() 


func _on_enemy_path_1_deactivation_timer_timeout():
	set_process(false)     
	if isCycle:
		activationTime.start() 
