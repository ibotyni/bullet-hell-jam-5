extends Path2D

var timer = 0
@export var spawnTime = 1

var follower = preload("res://path_follow_2d_Red_Bandit_Scout.tscn")

@onready var activationTime: Timer = $EnemyPath1ActivationTimer
@onready var deactivationTime: Timer = $EnemyPath1DeactivationTimer

@export var isCycle: bool = false

func _ready():
	set_process(false)
	deactivationTime.stop()

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
	else:
		set_process(false)
