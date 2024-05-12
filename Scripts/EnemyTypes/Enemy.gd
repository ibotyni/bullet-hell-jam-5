class_name Enemy extends Area2D

signal defeated

@export var speed = 50.0
@export var health = 3
@export var points = 100 
@export var damage = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $Healthbar  # Reference to your health bar node
@onready var health_bar_timer: Timer = $HealthBarTimer   # Timer for health bar visibility
@export var health_bar_duration: float = 2.0  # Duration the health bar is visible after damage

func _ready():
	health_bar.hide()  # Hide health bar initially
	health_bar_timer.wait_time = health_bar_duration  # Set timer duration

func _physics_process(delta):
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func die():
	$SfxExplode.play()
	queue_free()

func take_damage(amount):
	$SfxHitHurt.play()
	health -= amount
	if health <= 0: 
		defeated.emit(points)
		die()
	else: 
		update_health_bar()

func update_health_bar():
	health_bar.value = health
	health_bar.show()
	health_bar_timer.start()

func _on_HealthBarTimer_timeout():
	health_bar.hide()

func _on_body_entered(body):
	if body is Player:
		body.take_damage(damage)
