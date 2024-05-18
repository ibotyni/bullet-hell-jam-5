extends Area2D

signal damagePass

# Export bullet properties
@export var speed = 600
@export var damage = 1
@export var rotates: bool = false   # Added boolean to control rotation
@export var rotation_speed: float = 180.0 # Degrees per second 

var velocity = Vector2.ZERO

func _ready():
	start_moving()

func start_moving():
	velocity = Vector2.DOWN.rotated(rotation) * speed
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	position += velocity * delta

	if rotates:
		rotate(deg_to_rad(rotation_speed) * delta)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		print("player found")
		var player = body as Player
		damagePass.connect(player.take_damage)
		_on_player_hit()

func take_damage(_damage):
	pass

func _on_player_hit():
	damagePass.emit(damage)
