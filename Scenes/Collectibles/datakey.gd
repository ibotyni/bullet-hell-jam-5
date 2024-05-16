class_name DataKey extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
@onready var particles: CPUParticles2D = $CPUParticles2D

signal key_collected 


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)



func _on_body_entered(body):
	if body is Player:  # Check if it's the player
		key_collected.emit()  # Emit the signal
		queue_free()  # Optional: Remove the DataKey
