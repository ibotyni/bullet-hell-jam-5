class_name Moola extends Area2D

signal collected

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var expiration_timer: Timer = $PickupExpire
@export var expiration: float = 10.0
@export var speed = 100

@export var worth = 25



func _ready():
	expiration_timer.wait_time = expiration
	expiration_timer.start()

func _physics_process(delta):
	global_position.y += speed * delta

func _on_body_entered(body):
	if body is Player:
		print ("player found")
		_on_collection()

func _on_collection():
	collected.emit(worth)
	queue_free()

func _on_expire_timer_end():
	queue_free()
