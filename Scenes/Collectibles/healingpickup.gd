class_name HealthPickup extends Area2D
signal collected

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var expiration_timer: Timer = $PickupExpire

@export var expiration: float = 10.0
@export var speed = 100
@export var heal_amount = 25  # Amount of health to restore
@export var full_heal: bool = false # Toggle for full healing

func _ready():
	expiration_timer.wait_time = expiration
	expiration_timer.start()

func _physics_process(delta):
	global_position.y += speed * delta

func _on_body_entered(body):
	if body is Player:
		var player = body as Player
		collected.connect(player.heal)
		_on_collection()

func _on_collection():
# Emit either heal_amount or -1 to signal full heal
	if full_heal:
		collected.emit(-1)  
	else:
		collected.emit(heal_amount)
	queue_free()

func _on_expire_timer_end():
	queue_free()
