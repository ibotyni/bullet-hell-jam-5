class_name DataKey extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collisionShape2D: CollisionShape2D = $CollisionShape2D
@onready var particles: CPUParticles2D = $CPUParticles2D

signal key_collected

func _on_body_entered(body):
	if body is Player: 
		key_collected.emit()  
		body.datakeys_collected += 1
		print("Datakeys collected:", body.datakeys_collected)

		# Directly change the scene to the Galaxy Map
		get_tree().change_scene_to_file("res://Scenes/Levels/galaxy_map.tscn")  
		queue_free()
