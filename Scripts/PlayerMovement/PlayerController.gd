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

	# Clamp player position within camera limits (now after move_and_slide)
	var viewport_rect = get_viewport_rect()
	var camera_limits = viewport_rect.size

	position.x = clamp(position.x, viewport_rect.position.x + 
	$Sprite2D.texture.get_width() / 2, viewport_rect.position.x + camera_limits.x - $Sprite2D.texture.get_width() / 2)
	
	position.y = clamp(position.y, viewport_rect.position.y + 
	$Sprite2D.texture.get_height() / 2, viewport_rect.position.y + camera_limits.y - $Sprite2D.texture.get_height() / 2)
