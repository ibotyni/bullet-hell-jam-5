class_name Player extends CharacterBody2D

# Inspector Variables
@export var acceleration: float = 0.05
@export var deceleration: float = 0.08
@export var max_speed: float = 200.0
@export var viewport_size = Vector2(640, 360)
@export var max_health: float = 100.0   # Maximum health of the player
@export var health_bar_duration: float = 2.0  # Duration the health bar is visible after damage

#Health variables
var health: float = max_health
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar =  $PlayerUI/Healthbar # Reference to your health bar node
@onready var health_bar_timer: Timer = $HealthBarTimer   # Timer for health bar visibility
signal dead

#Atack Logic variables
signal bullet_shot(bullet_scene, location)
@onready var projectileSpawnA = $projectile_spawn
var projectile_bullet = preload("res://Scenes/Player/Projectiles/bullet.tscn")
var projectile_cooldown : = false
@export var rate_of_fire := 0.25

#Sound Effects
@onready var shooting_sfx = $ShootingSFX

#fade effects
var fade_duration: float = 3.0  # Time for the fade-out effect
var time_elapsed: float = 0.0   # Tracks the time since fade started

#Moola
var player_wallet = 0
var moola = Moola 
@onready var moola_icon : TextureRect = $PlayerUI/MoolaPicture
@onready var moola_counter = $PlayerUI/MoolaDisplay:
	set(value):
		moola_counter.text = "X: " + str(value)
@onready var moola_timer: Timer = $PlayerUI/MoolaTimer

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("shoot"):
		if !projectile_cooldown:
			projectile_cooldown = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			projectile_cooldown = false

	# Get movement input from both arrow keys and WASD keys
	if Input.is_action_pressed("up") or Input.is_action_pressed("up_w"):
		direction.y -= acceleration
	if Input.is_action_pressed("down") or Input.is_action_pressed("down_s"):
		direction.y += acceleration
	if Input.is_action_pressed("left") or Input.is_action_pressed("left_a"):
		direction.x -= acceleration
	if Input.is_action_pressed("right") or Input.is_action_pressed("right_d"):
		direction.x += acceleration

	# Normalize direction for consistent speed
	direction = direction.normalized()

	# Accelerate towards target velocity
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, acceleration)

	# Decelerate when there's no input
	if direction == Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, deceleration)

	move_and_slide()

	# Clamp normalized direction for animation
	direction.x = clamp(direction.x, -1, 1)
	direction.y = clamp(direction.y, -1, 1)


	# Animation logic (using Sprite2D)
	if direction.x < 0:
		if direction.x < -0.5:
			$Sprite2D.frame = 4
		else:
			$Sprite2D.frame = 3
	elif direction.x > 0:
		if direction.x > 0.5:
			$Sprite2D.frame = 0
		else:
			$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 2

	# Clamp player position within camera limits (after move_and_slide)
	position.x = clamp(position.x, $Sprite2D.texture.get_width() / 2, viewport_size.x - $Sprite2D.texture.get_width() / 2)
	position.y = clamp(position.y, $Sprite2D.texture.get_height() / 2, viewport_size.y - $Sprite2D.texture.get_height() / 2)
	
	if time_elapsed < fade_duration:
		# Calculate the fade progress (0 to 1)
		var fade_progress = time_elapsed / fade_duration

		# Adjust the alpha (modulate) of the UI elements
		moola_counter.modulate.a = 1 - fade_progress
		
		# Manually adjust the alpha of the TextureRect
		var new_color = moola_icon.modulate
		new_color.a = 1 - fade_progress
		moola_icon.modulate = new_color

		time_elapsed += delta
	else:
		# Hide UI elements completely after fade-out
		moola_counter.visible = false
		moola_icon.visible = false

func _ready():
	health_bar.visible = false
	health_bar_timer.wait_time = health_bar_duration
	moola_counter.visible = false
	moola_icon.visible = false
	moola_timer.wait_time = moola_timer.wait_time # time before fade
	moola_timer.one_shot = true

func _on_Moola_collected(worth):
	player_wallet += worth
	# Update the Moola display label
	moola_counter.text = str(player_wallet)
	
	#Show the moola dispay and icon
	moola_counter.visible = true
	moola_icon.visible = true
	
	#Reset fading variables
	moola_counter.modulate.a = 1.0
	moola_icon.modulate.a = 1.0
	time_elapsed = 0.0

	#Start the timer
	moola_timer.start()
	

func _on_MoolaTimer_timeout():
	#Hide UI elements
	time_elapsed = 0.0

func take_damage(amount):
	print("Player taking damage:", amount)  # Add this print statement
	health -= amount
	health = clamp(health, 0, max_health)
	print("Player health after damage:", health)  # Add this print statement
	if health <= 0:
		die()
	else:
		update_health_bar()

func update_health_bar():
	health_bar.value = health
	health_bar.visible = true
	health_bar_timer.start()



func shoot():
	# Create a new bullet instance
	var bullet = projectile_bullet.instantiate()
	
	# Set the bullet's position and rotation based on the player's projectile spawn point
	bullet.global_position = projectileSpawnA.global_position
	bullet.rotation = projectileSpawnA.global_rotation  
	
	# Add the bullet to the scene tree
	get_parent().add_child(bullet)
	shooting_sfx.play()

func die():
	dead.emit()
	queue_free()


func _on_health_bar_timer_timeout():
	health_bar.hide()



