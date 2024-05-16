class_name Bandit extends Area2D



@export var isPath = false 


#Movement:
@export var is_move_x = true       # Control movement on the X-axis
@export var is_move_y = true       # Control movement on the Y-axis
@export var x_speed = 50.0          # Speed on the X-axis
@export var y_speed = 50.0          # Speed on the Y-axis
@export var min_x = 0.0     # Minimum X-coordinate boundary
@export var max_x = 600.0   # Maximum X-coordinate boundary
@export var target_y = 200.0 

#Attack
@onready var idle : Sprite2D = $IdleSprite
@onready var attack : Sprite2D = $AttackSprite
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var left_cannon : Marker2D = $LeftCan
@onready var right_cannon: Marker2D = $RightCan
var time_since_last_shot := 0.0
@export var rate_of_fire := 0.5 # Adjust this to control the firing rate
@export var enemy_projectile = preload("res://Scenes/Player/Projectiles/enemyProjectile.tscn")
signal damagePass
signal defeated

#BaseStats
@export var health = 3
@export var points = 100
@export var damage = 3

#Inventory
@export var drop_all_items_on_death: bool = false  # NEW: Boolean for controlling drops
@export var drop_items: Array[PackedScene] = []
@export var drop_chance = 0.5

#HealthBar
@onready var health_bar: ProgressBar = $Healthbar
@onready var health_bar_timer: Timer = $HealthBarTimer
@export var health_bar_duration: float = 2.0

func _ready():
	health_bar.hide()
	health_bar_timer.wait_time = health_bar_duration
	if isPath:  # Disable movement if isPath is true
		is_move_x = false
		is_move_y = false
		x_speed = 0
		y_speed = 0


func _physics_process(delta):
	time_since_last_shot += delta
	shoot()
	if isPath:  # Don't execute movement if isPath is true
		return 
	if is_move_x and is_move_y:
		move_diagonally(delta)
	elif is_move_x and not is_move_y:
		move_horizontally_after_reaching_target_y(delta)
	elif not is_move_x and is_move_y:
		move_vertically_only(delta)

func shoot():
	if time_since_last_shot >= rate_of_fire:
		attack.visible = true
		var left_projectile = enemy_projectile.instantiate()
		left_projectile.global_position = to_global(left_cannon.position)  # Use to_global()
		left_projectile.rotation = left_cannon.global_rotation
		get_parent().add_child(left_projectile)
		var right_projectile = enemy_projectile.instantiate()
		right_projectile.global_position = to_global(right_cannon.position)  # Use to_global()
		right_projectile.rotation = right_cannon.global_rotation
		get_parent().add_child(right_projectile)
		attack.visible = false

		time_since_last_shot = 0.0

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# --- Movement Functions ---

func move_diagonally(delta):
	global_position.x += x_speed * delta
	global_position.y += y_speed * delta
	# Clamp X movement within boundaries
	global_position.x = clamp(global_position.x, min_x, max_x)
	if global_position.x == min_x or global_position.x == max_x:
		x_speed *= -1

func move_horizontally_after_reaching_target_y(delta):
	if abs(global_position.y - target_y) > 1:  # Check if at target_y yet
		global_position.y += y_speed * delta
	else:
		global_position.x += x_speed * delta
		global_position.x = clamp(global_position.x, min_x, max_x)
		if global_position.x == min_x or global_position.x == max_x:
			x_speed *= -1

func move_vertically_only(delta):
	global_position.y += y_speed * delta


func die():
	$SfxExplode.play()

	if drop_all_items_on_death:
		for item_scene in drop_items:
			var new_item = item_scene.instantiate()
			
			# --- Calculate Random Offset for Item Placement ---
			var random_offset = Vector2(
				randf_range(-20, 20),  # Adjust the range for desired spacing
				randf_range(-20, 20)
			)
			# --- Apply Offset to Item Position ---
			new_item.global_position = global_position + random_offset  

			get_parent().add_child(new_item)
	else:
		if randf() < drop_chance and drop_items.size() > 0:
			var random_item = drop_items.pick_random().instantiate()
			random_item.global_position = global_position
			get_parent().add_child(random_item)

	call_deferred("queue_free")

func take_damage(amount):
	$SfxHitHurt.play()
	health -= amount
	if health <= 0:
		defeated.emit(points)
		call_deferred("die")
	else:
		update_health_bar()

func update_health_bar():
	health_bar.value = health
	health_bar.show()
	health_bar_timer.start()



func _on_body_entered(body):
	if body is Player:
		print("player found")
		
		# Get the Player instance and connect the signal
		var player = body as Player
		damagePass.connect(player.take_damage)
		
		_on_player_hit()

func _on_player_hit():
	damagePass.emit(damage)



func _on_health_bar_timer_timeout():
	health_bar.hide() 



