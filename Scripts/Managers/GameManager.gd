extends Node

#EnemyManager
@export var enemy_scenes: Array[PackedScene] = []
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer

#Grab the HUD
@onready var hud = $GeneralUI/HUD


 # Reference to your player character
@onready var player_spawn_point = $playerSpawn
@onready var projectile_container = $ProjectileContainer

@onready var player: CharacterBody2D = null
var score := 0:
	set(value):
		score = value
		hud.score = score



func _ready():
	score = 0
	player = get_node("Protoship")  # Get the player node from the root
	player.global_position = player_spawn_point.global_position
	player.bullet_shot.connect(_on_protoship_bullet_shot)

	# Check if the player was found
	if player == null:
		print("Error: Player node not found!")
	else:
		print("Player found successfully!")


func _on_protoship_bullet_shot(bullet_scene, location):
	var bullet = bullet_scene.instantiate() 
	bullet.global_position = location
	projectile_container.add_child(bullet)



func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2 (randf_range(80, 560),randf_range(-20, -10))
	e.defeated.connect(_on_enemy_killed)
	enemy_container.add_child(e)

func _on_enemy_killed(points):
	score += points
	print(score)
