extends CharacterBody2D

@export var speed = 200 # Make speed adjustable in the Inspector

func _physics_process(_delta):
	var direction = Vector2.ZERO

	# Get movement input from both arrow keys and WASD keys
	if Input.is_action_pressed("up") or Input.is_action_pressed("up_w"):
		direction.y -= 1
	if Input.is_action_pressed("down") or Input.is_action_pressed("down_s"):
		direction.y += 1
	if Input.is_action_pressed("right") or Input.is_action_pressed("right_d"):
		direction.x += 1
	if Input.is_action_pressed("left") or Input.is_action_pressed("left_a"):
		direction.x -= 1

	# Normalize direction and apply speed
	direction = direction.normalized()
	velocity = direction * speed 

	move_and_slide()
