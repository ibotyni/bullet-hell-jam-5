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

#Boss Timer logic
@onready var boss_timer: Timer = $BossTimer
@onready var boss_marker: Marker2D = $BossSpawn
@export var boss_scene: PackedScene  # Export to expose in Inspector
var isBoss := false 




func _ready():
	var _save_file = FileAccess.open("user://save.data", FileAccess.READ)
	enemy_spawn_timer = $EnemySpawnTimer
	moola_spawn_timer = $MoolaSpawnTimer
	score = 0
	player = get_node("Protoship")
	player.global_position = player_spawn_point.global_position
	player.dead.connect(_on_player_dead)
	game_over_screen.set_process(false)
	hud.visible = false

	pause_menu.visible = false
	pause_menu.set_process(false) # Ensure the pause menu is hidden initially
	# Boss Timer Setup
	boss_timer.timeout.connect(_on_boss_timer_timeout)  # Connect the timeout signal
	boss_timer.one_shot = true  # Make the timer run only once

func _on_boss_timer_timeout():
	# Destroy all enemies
	for child in enemy_container.get_children():
		child.queue_free()  
	# Spawn the boss
	var boss = boss_scene.instantiate()
	boss.global_position = boss_marker.global_position
	get_parent().add_child(boss)
	isBoss = true 

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
	
	if isBoss:  # Clear enemies if boss battle is active
		for child in enemy_container.get_children():
			child.queue_free()







func _on_enemy_spawn_timer_timeout():
	if not isBoss:  # Only spawn enemies if not in boss battle
		var e = enemy_scenes.pick_random().instantiate()
		e.global_position = Vector2(randf_range(60, 580), randf_range(-20, -10))
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
