extends Area2D

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
	velocity = Vector2.UP.rotated(rotation) * speed
	velocity = velocity.normalized() * speed  # Ensure consistent speed

func _physics_process(delta):
	# Continuous movement in the chosen direction
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Enemy or area is Bandit or area is BanditDisk:
		area.take_damage(damage)  # Use the 'damage' variable assigned from the player
		queue_free()
