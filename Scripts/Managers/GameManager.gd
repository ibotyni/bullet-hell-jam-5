class_name GameManager extends Node

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

#Pause Menu
@onready var pause_menu = $GeneralUI/PauseMenu

# Reference to the player character and their spawn
@onready var player_spawn_point = $playerSpawn
@onready var projectile_container = $ProjectileContainer
@onready var player: CharacterBody2D = null

var score := 0:
	set(value):
		score = value
		hud.score = score


func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	enemy_spawn_timer = $EnemySpawnTimer
	moola_spawn_timer = $MoolaSpawnTimer
	score = 0
	player = get_node("Protoship")
	player.global_position = player_spawn_point.global_position
	player.dead.connect(_on_player_dead)
	game_over_screen.set_process(false)
	pause_menu.visible = false
	pause_menu.set_process(false) # Ensure the pause menu is hidden initially

func _process(delta):
	if enemy_spawn_timer.wait_time > 0.4:
		enemy_spawn_timer.wait_time -= delta*0.09
	elif enemy_spawn_timer.wait_time < 0.4:
				enemy_spawn_timer.wait_time = 0.4
	
	bg.scroll_offset.y += delta*bg_scroll_speed
	if bg.scroll_offset.y >= 400:
		bg.scroll_offset.y = 0
	if Input.is_action_just_pressed("esc"):
		pause_menu.set_process(true)
		get_tree().paused = not get_tree().paused#Toggle pause state
		pause_menu.visible = get_tree().paused







func _on_enemy_spawn_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2 (randf_range(80, 560),randf_range(-20, -10))
	e.defeated.connect(_on_enemy_killed) 
	enemy_container.add_child(e)

func _on_enemy_killed(points):
	score += points

func _on_player_dead():
	game_over_screen.set_process(true)
	game_over_screen.set_score(score)
	await get_tree().create_timer(1.5).timeout
	game_over_screen.visible = true


func _on_moola_spawn_timer_timeout():
	var m = moola_scenes.pick_random().instantiate()
	m.global_position = Vector2 (randf_range(80, 560),randf_range(-20, -10))
	moola_container.add_child(m)



func _on_game_over_menu_to_main_menu():
	get_tree().change_scene_to_file("res://Scenes/Levels/MainMenu/main_menu_scene.tscn")


func _on_pause_menu_redirect_quit():
	print ("pause pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Levels/MainMenu/main_menu_scene.tscn")
