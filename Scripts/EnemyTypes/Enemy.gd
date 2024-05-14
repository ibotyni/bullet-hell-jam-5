class_name Enemy extends Area2D

signal damagePass
signal defeated

@export var speed = 50.0
@export var health = 3
@export var points = 100
@export var damage = 3
@export var drop_all_items_on_death: bool = false  # NEW: Boolean for controlling drops

@export var drop_items: Array[PackedScene] = []
@export var drop_chance = 0.5

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $Healthbar
@onready var health_bar_timer: Timer = $HealthBarTimer
@export var health_bar_duration: float = 2.0

func _ready():
	health_bar.hide()
	health_bar_timer.wait_time = health_bar_duration

func _physics_process(delta):
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func die():
	$SfxExplode.play()

	if drop_all_items_on_death:
		for item_scene in drop_items:
			var new_item = item_scene.instantiate()
			
			# --- Calculate Random Offset for Item Placement ---
			var random_offset = Vector2(
				randf_range(-20, 20),  # Adjust the range for desired spacing
				randf_range(-20, 20)
			)
			# --- Apply Offset to Item Position ---
			new_item.global_position = global_position + random_offset  

			get_parent().add_child(new_item)
	else:
		if randf() < drop_chance and drop_items.size() > 0:
			var random_item = drop_items.pick_random().instantiate()
			random_item.global_position = global_position
			get_parent().add_child(random_item)

	call_deferred("queue_free")

func take_damage(amount):
	$SfxHitHurt.play()
	health -= amount
	if health <= 0:
		defeated.emit(points)
		call_deferred("die")
	else:
		update_health_bar()

func update_health_bar():
	health_bar.value = health
	health_bar.show()
	health_bar_timer.start()



func _on_body_entered(body):
	if body is Player:
		print("player found")
		
		# Get the Player instance and connect the signal
		var player = body as Player
		damagePass.connect(player.take_damage)
		
		_on_player_hit()

func _on_player_hit():
	damagePass.emit(damage)



func _on_health_bar_timer_timeout():
	health_bar.hide() 
