class_name Player extends CharacterBody2D

# Inspector Variables
@export var acceleration: float = 500.0
@export var deceleration: float = 800.0
@export var max_speed: float = 200.0
@export var viewport_size = Vector2(640, 360)
@export var max_health: float = 100.0   # Maximum health of the player
@export var health_bar_duration: float = 2.0  # Duration the health bar is visible after damage

var health: float = max_health
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $Healthbar  # Reference to your health bar node
@onready var health_bar_timer: Timer = $HealthBarTimer   # Timer for health bar visibility
signal dead

#Atack Logic
signal bullet_shot(bullet_scene, location)
@onready var projectileSpawnA = $projectile_spawn
var projectile_bullet = preload("res://Scenes/Player/Projectiles/bullet.tscn")
var projectile_cooldown : = false
@export var rate_of_fire := 0.25




func _physics_process(_delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("shoot"):
		if !projectile_cooldown:
			projectile_cooldown = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			projectile_cooldown = false

	# Get movement input from both arrow keys and WASD keys
	if Input.is_action_pressed("up") or Input.is_action_pressed("up_w"):
		direction.y -= 1
	if Input.is_action_pressed("down") or Input.is_action_pressed("down_s"):
		direction.y += 1
	if Input.is_action_pressed("left") or Input.is_action_pressed("left_a"):
		direction.x -= 1
	if Input.is_action_pressed("right") or Input.is_action_pressed("right_d"):
		direction.x += 1

	# Normalize direction for consistent speed
	direction = direction.normalized()

	# Accelerate towards target velocity
	var target_velocity = direction * max_speed
	velocity = velocity.lerp(target_velocity, acceleration * _delta)

	# Decelerate when there's no input
	if direction == Vector2.ZERO:
		velocity = velocity.lerp(Vector2.ZERO, deceleration * _delta)

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


func _ready():
	health_bar.hide()  # Hide health bar initially
	health_bar_timer.wait_time = health_bar_duration  # Set timer duration

func take_damage(amount):
	health -= amount
	health = clamp(health, 0, max_health)  # Ensure health stays within bounds
	update_health_bar()

func update_health_bar():
	health_bar.value = health
	health_bar.show()
	health_bar_timer.start()

func _on_HealthBarTimer_timeout():
	health_bar.hide()

func shoot():
	bullet_shot.emit(projectile_bullet, projectileSpawnA.global_position)

func die():
	dead.emit()
	queue_free()
