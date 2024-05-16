extends Area2D

signal damagePass

# Export bullet properties
@export var speed = 600
@export var damage = 1

var velocity = Vector2.ZERO  # Declare velocity here

# This function is called when the bullet is instantiated.
func _ready():
	# Start moving immediately upon creation
	start_moving()

# Function to handle bullet movement
func start_moving():
	velocity = Vector2.DOWN.rotated(rotation) * speed
	velocity = velocity.normalized() * speed  # Ensure consistent speed

func _physics_process(delta):
	# Continuous movement in the chosen direction
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		print("player found")
		
		# Get the Player instance and connect the signal
		var player = body as Player
		damagePass.connect(player.take_damage)
		
		_on_player_hit()

func take_damage(_damage):
	pass

func _on_player_hit():
	damagePass.emit(damage)
