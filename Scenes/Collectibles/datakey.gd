class_name DataKey extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
@onready var particles: CPUParticles2D = $CPUParticles2D

@export var connected_scene: String


signal key_collected 


# Called when the node enters the scene tree for the first time.




func _on_body_entered(body):
	if body is Player:  # Check if it's the player
		key_collected.emit()  # Emit the signal
		body.datakeys_collected += 1       # Increment player's count
		print("Datakeys collected:", body.datakeys_collected) 
		scene_manager.change_scene(get_owner(), connected_scene)
		queue_free()  # Optional: Remove the DataKey
