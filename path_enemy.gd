class_name PathedEnemy extends Node2D

@onready var path2D: Path2D = $Path2D
@onready var pathFollow2D: PathFollow2D = $Path2D/PathFollow2D

@onready var active_timer: Timer = $ActiveTimer
@onready var spawn_interval: Timer = $SpawnInterval
@onready var deactive_timer: Timer = $DeactiveTimer



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
