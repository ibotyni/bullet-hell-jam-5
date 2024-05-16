extends Path2D

@export var speed = 1
@export var spawnable_scenes: Array[PackedScene] = []  # Array of enemies/bandits
@export var spawn_interval = 5.0                   # Time between spawns
@export var initial_speed = 0.0

@onready var progress_ratio: PathFollow2D = $PathFollow2D
@onready var spawn_timer = $SpawnTimer

@onready var vortex_body: AnimatedSprite2D = $PathFollow2D/VortexBody
@onready var vortex_effect: AnimatedSprite2D = $PathFollow2D/VortexEffect

func _ready():
	spawn_timer.wait_time = spawn_interval  # Initialize the timer
	spawn_timer.start()                     # Start the spawn timer

func _process(delta):
	progress_ratio.progress_ratio += delta * speed

func _on_spawn_timer_timeout():
	if spawnable_scenes.size() > 0:
		var enemy_scene = spawnable_scenes.pick_random()
		var enemy = enemy_scene.instantiate() as Enemy or Bandit  
		
		enemy.velocity = Vector2.ZERO
		enemy.position = progress_ratio.global_position 
		enemy.set("speed", initial_speed)

		get_parent().add_child(enemy)  # Add to the same parent as the path

	spawn_timer.start()  # Restart the timer
