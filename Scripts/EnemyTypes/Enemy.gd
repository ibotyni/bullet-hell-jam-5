class_name Enemy extends Area2D

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

	# --- Drop Item Logic (Modified) ---
	
	if drop_all_items_on_death:
		for item_scene in drop_items:  # Drop all items
			var new_item = item_scene.instantiate()
			new_item.global_position = global_position
			get_parent().add_child(new_item)
	else:
		if randf() < drop_chance and drop_items.size() > 0:  # Drop random item
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
		body.take_damage(damage)


func _on_health_bar_timer_timeout():
	health_bar.hide() 
