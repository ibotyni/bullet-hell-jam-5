extends Node

@onready var player: CharacterBody2D = null # Reference to your player character
@onready var player_spawn_point = $playerSpawn
@onready var projectile_container = $ProjectileContainer

func _ready():
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
