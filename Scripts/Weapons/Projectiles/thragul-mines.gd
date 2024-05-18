extends Area2D

# Export bullet properties
@export var speed = 100
@export var damage = 10

var velocity = Vector2.ZERO  # Declare velocity here

var in_danger : Area2D = null

# This function is called when the bullet is instantiated.
func _ready():
	# Start moving immediately upon creation
	start_moving()

# Function to handle bullet movement
func start_moving():
	velocity = Vector2.UP.rotated(rotation) * speed
	velocity = velocity.normalized() * speed  # Ensure consistent speed

func _physics_process(delta):
	if speed > 10:
		$CollisionShape2D.disabled = true
		speed -= 1
	else:
		$CollisionShape2D.disabled = false
		
	velocity = Vector2.UP.rotated(rotation) * speed
	velocity = velocity.normalized() * speed  # Ensure consistent speed
	# Continuous movement in the chosen direction
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Enemy or area is Bandit:
		print("area: ", area)
		area.take_damage(damage)  # Use the 'damage' variable assigned from the player
		queue_free()


func _on_body_entered(body):
	if body is Player:
		print("body: ", body)
		body.take_damage(damage)  # Use the 'damage' variable assigned from the player
		queue_free()
