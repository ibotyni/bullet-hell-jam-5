class_name Bandit extends Area2D


@export var speed = 50.0

@onready var idle : Sprite2D = $IdleSprite
@onready var attack : Sprite2D = $AttackSprite
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var left_cannon : Marker2D = $LeftCan
@onready var right_cannon: Marker2D = $RightCan



func _ready():
	idle.visible = true
	attack.visible = false

func _physics_process(delta):
	global_position.y += speed * delta
	


