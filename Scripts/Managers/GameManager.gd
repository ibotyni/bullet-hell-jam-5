extends Node

#EnemyManager
@export var enemy_scenes: Array[PackedScene] = []
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer

#Grab the HUD
@onready var hud = $GeneralUI/HUD
@onready var game_over_screen = $GeneralUI/GameOverMenu

 # Reference to your player character
@onready var player_spawn_point = $playerSpawn
@onready var projectile_container = $ProjectileContainer

@onready var player: CharacterBody2D = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score 



func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!=null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
	score = 0
	player = get_node("Protoship")  # Get the player node from the root
	player.global_position = player_spawn_point.global_position
	player.bullet_shot.connect(_on_protoship_bullet_shot)
	player.dead.connect(_on_player_dead)

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)


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
	if score > high_score: 
		high_score = score

func _on_player_dead():
	game_over_screen.set_score(score)
	game_over_screen.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(1.5).timeout
	game_over_screen.visible = true
