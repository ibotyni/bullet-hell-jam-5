extends Node

#Background
@onready var bg = $ScrollingBackground
@export var bg_scroll_speed = 100

#EnemyManager
@export var enemy_scenes: Array[PackedScene] = []
@export var enemy_spawn_timer = 0
@onready var enemy_container = $EnemyContainer

#MoolaSpawner
@export var moola_scenes: Array[PackedScene] = []
@export var moola_spawn_timer = 0
@onready var moola_container = $MoolaContainer


#Grab the HUD
@onready var hud = $GeneralUI/HUD
@onready var game_over_screen = $GeneralUI/GameOverMenu

 # Reference to the player character and their spawn
@onready var player_spawn_point = $playerSpawn
@onready var projectile_container = $ProjectileContainer
@onready var player: CharacterBody2D = null

var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score 

var cash := 0:
	set(value):
		cash = value
		hud.wallet = cash
var total_cash = 0




func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	enemy_spawn_timer = $EnemySpawnTimer
	moola_spawn_timer = $MoolaSpawnTimer
	if save_file!=null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
	score = 0
	if save_file!=null:
		cash = save_file.get_32()
		print ("Save Found")
	else:
		cash = 100
		save_game()
	player = get_node("Protoship")  # Get the player node from the root
	player.global_position = player_spawn_point.global_position
	player.bullet_shot.connect(_on_protoship_bullet_shot)
	player.dead.connect(_on_player_dead)
	game_over_screen.set_process(false)
	var global_manager = get_node("/root/GlobalManager")
	if global_manager:
		cash = global_manager.cash
		hud.wallet = cash

func _process(delta):
	if enemy_spawn_timer.wait_time > 0.4:
		enemy_spawn_timer.wait_time -= delta*0.09
	elif enemy_spawn_timer.wait_time < 0.4:
				enemy_spawn_timer.wait_time = 0.4
	
	bg.scroll_offset.y += delta*bg_scroll_speed
	if bg.scroll_offset.y >= 400: 
		bg.scroll_offset.y = 0

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)
	save_file.store_32(cash)


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
	game_over_screen.set_process(true)
	game_over_screen.set_score(score)
	game_over_screen.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(1.5).timeout
	game_over_screen.visible = true


func _on_moola_spawn_timer_timeout():
	var m = moola_scenes.pick_random().instantiate()
	m.global_position = Vector2 (randf_range(80, 560),randf_range(-20, -10))
	m.collected.connect(_on_moola_collected)
	moola_container.add_child(m)

func _on_moola_collected(worth):
	var global_manager = get_node("/root/GlobalManager")
	if global_manager:
		global_manager.cash += worth
		hud.wallet = global_manager.cash  # Update HUD
		global_manager.save_game()


func _on_game_over_menu_to_main_menu():
	get_tree().change_scene_to_file("res://Scenes/Levels/MainMenu/main_menu_scene.tscn")


func _on_pause_menu_redirect_quit():
	get_tree().change_scene_to_file("res://Scenes/Levels/MainMenu/main_menu_scene.tscn")
