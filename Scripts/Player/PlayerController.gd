class_name Player extends CharacterBody2D

# Inspector Variables
@export var acceleration: float = 0.05
@export var deceleration: float = 0.08
@export var viewport_size = Vector2(640, 360)
@export var health_bar_duration: float = 2.0  # Duration the health bar is visible after damage
@export var bullet_damage = 1

#Health variables
var health: int
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar =  $PlayerUI/Healthbar # Reference to your health bar node
@onready var health_bar_timer: Timer = $HealthBarTimer   # Timer for health bar visibility
signal dead

# Knockback variables
@export var knockback_strength = 200.0  # Exported variable for knockback strength
var knockback_velocity := Vector2.ZERO
@export var knockback_decay := 0.9  # Rate at which knockback decreases per frame
var stunned := false
@export var stun_duration := 0.2 # Duration of stun in seconds

# Invincibility variables
@export var invincibility_duration = 1.0  # Time the player is invincible after getting hit
var is_invincible := false
var blink_timer := 0.0
@export var blink_interval = 0.1  # Time between blinks

#Store
@export var in_store: bool = false
@export var mute_sfx: bool = false

var ship_type: Enums.ShipType = Enums.ShipType.MINAHASA

var global : Node
var glob_weapons : Node

#fade effects
var fade_duration: float = 3.0  # Time for the fade-out effect
var time_elapsed: float = 0.0   # Tracks the time since fade started

#Moola
var player_wallet = 10000
var moola = Moola 
@onready var moola_icon : TextureRect = $PlayerUI/MoolaPicture
@onready var moola_counter = $PlayerUI/MoolaDisplay:
	set(value):
		moola_counter.text = "X: " + str(value)
@onready var moola_timer: Timer = $PlayerUI/MoolaTimer

#Datakeys
@export var datakeys_collected = 0

func _on_datakey_collected():
	datakeys_collected += 1
	print("Datakeys collected:", datakeys_collected)



func _physics_process(delta):
	# also sets the firing state of the weapons when shoot is pressed
	check_and_change_weapons()
	
	# in the store, nothing more to do
	if in_store:
		return
	# Handle invincibility timer
	if is_invincible:
		blink_timer += delta
		if blink_timer >= blink_interval:
			sprite.visible = not sprite.visible 
			blink_timer = 0.0
		
		invincibility_duration -= delta
		if invincibility_duration <= 0:
			is_invincible = false
			sprite.visible = true 

	if stunned:
		stun_duration -= delta
		if stun_duration <= 0:
			stunned = false
	else:  # Only process movement if not stunned
		var direction = Vector2.ZERO
		# Get movement input from both arrow keys and WASD keys
		if Input.is_action_pressed("up") or Input.is_action_pressed("up_w"):
			direction.y -= acceleration
		if Input.is_action_pressed("down") or Input.is_action_pressed("down_s"):
			direction.y += acceleration
		if Input.is_action_pressed("left") or Input.is_action_pressed("left_a"):
			direction.x -= acceleration
		if Input.is_action_pressed("right") or Input.is_action_pressed("right_d"):
			direction.x += acceleration

		# Normalize direction for consistent speed
		direction = direction.normalized()

		# Accelerate towards target velocity
		var target_velocity = direction * global.max_speed
		velocity = velocity.lerp(target_velocity, acceleration)

		# Decelerate when there's no input
		if direction == Vector2.ZERO:
			velocity = velocity.lerp(Vector2.ZERO, deceleration)
		
			# Clamp normalized direction for animation
		direction.x = clamp(direction.x, -1, 1)
		direction.y = clamp(direction.y, -1, 1)


		# Animation logic (using Sprite2D)
		if direction.x < 0:
			if direction.x < -0.5:
				$Sprite2D.frame = 4
			else:
				$Sprite2D.frame = 3
		elif direction.x > 0:
			if direction.x > 0.5:
				$Sprite2D.frame = 0
			else:
				$Sprite2D.frame = 1
		else:
			$Sprite2D.frame = 2

   # Apply knockback while respecting screen boundaries
	if knockback_velocity != Vector2.ZERO:
		var new_position = position + knockback_velocity
		new_position.x = clamp(new_position.x, 0, viewport_size.x)
		new_position.y = clamp(new_position.y, 0, viewport_size.y)
		if new_position != position:  
			position = new_position
			knockback_velocity *= knockback_decay
		else:
			knockback_velocity = Vector2.ZERO 

	move_and_slide()

	# Clamp player position within camera limits (after move_and_slide)
	position.x = clamp(position.x, $Sprite2D.texture.get_width() / 2, viewport_size.x - $Sprite2D.texture.get_width() / 2)
	position.y = clamp(position.y, $Sprite2D.texture.get_height() / 2, viewport_size.y - $Sprite2D.texture.get_height() / 2)
	
	if time_elapsed < fade_duration:
		# Calculate the fade progress (0 to 1)
		var fade_progress = time_elapsed / fade_duration

		# Adjust the alpha (modulate) of the UI elements
		moola_counter.modulate.a = 1 - fade_progress
		
		# Manually adjust the alpha of the TextureRect
		var new_color = moola_icon.modulate
		new_color.a = 1 - fade_progress
		moola_icon.modulate = new_color

		time_elapsed += delta
	else:
		# Hide UI elements completely after fade-out
		moola_counter.visible = false
		moola_icon.visible = false

func _ready():
	global = get_node("/root/GlobalManager")
	glob_weapons = get_node("/root/Weapons")
	health = global.max_health
	
	health_bar.visible = false
	health_bar_timer.wait_time = health_bar_duration
	moola_counter.visible = false
	moola_icon.visible = false
	moola_timer.wait_time = moola_timer.wait_time # time before fade
	moola_timer.one_shot = true

func _on_Moola_collected(worth):
	player_wallet += worth
	# Update the Moola display label
	moola_counter.text = str(player_wallet)
	
	#Show the moola dispay and icon
	moola_counter.visible = true
	moola_icon.visible = true
	
	#Reset fading variables
	moola_counter.modulate.a = 1.0
	moola_icon.modulate.a = 1.0
	time_elapsed = 0.0

	#Start the timer
	moola_timer.start()


func _on_MoolaTimer_timeout():
	#Hide UI elements
	time_elapsed = 0.0


func take_damage(amount):
	if is_invincible:
		return  # Don't take damage if invincible

	health -= amount
	health = clamp(health, 0, global.max_health)

	# Reverse current velocity for knockback
	knockback_velocity = -velocity.normalized() * knockback_strength
	stunned = true
	stun_duration = 0.2

 # Trigger invincibility
	is_invincible = true
	invincibility_duration = 1.0 

	if health <= 0:
		die()
	else:
		update_health_bar()

func update_health_bar():
	health_bar.max_value = global.max_health
	health_bar.value = health
	health_bar.visible = true
	health_bar_timer.start()


func die():
	for child in $Sprite2D.get_children():
		child.visible = false
	sprite.visible = false
	is_invincible = false
	dead.emit()
	heal(-1)

	# Add a short delay before deactivating
	await get_tree().create_timer(1).timeout  # Adjust delay as needed (0.2 seconds here)

	set_process(false)
	set_physics_process(false)



func heal(amount):
	if amount == -1:  # Check for full heal signal
		health = global.max_health
	else:
		health += amount
		health = clamp(health, 0, global.max_health)

	update_health_bar()


func _on_health_bar_timer_timeout():
	health_bar.hide()

func check_and_change_weapons():
	if ship_type != global.ship_type:
		$Sprite2D.texture = load("res://Assets/Artwork/Ships/%s.png" % glob_weapons.ship_type_db[global.ship_type].res)
		ship_type = global.ship_type
	
	var weapon_change: bool = false
	
	# front weapon
	weapon_change = false
	# if there isn't a weapon in the slot, and there should be, then weapon change
	if $Sprite2D/FrontWeaponPosition.get_child_count() == 0:
		if global.front_weapon != Enums.WeaponName.NONE:
			weapon_change = true
	else:
		#print("get_child_count   ", $Sprite2D/FrontWeaponPosition.get_child_count())
		#print("global.front_weapon  ", global.front_weapon)
		#print("front weapon: ", $Sprite2D/FrontWeaponPosition.get_child(0).weapon_name)
		#print($Sprite2D/FrontWeaponPosition.get_child(0))
		# if the weapon in the slot isn't what it should be, then remove the old weapon
		if global.front_weapon != $Sprite2D/FrontWeaponPosition.get_child(0).weapon_name:
			$Sprite2D/FrontWeaponPosition.get_child(0).queue_free()
			return

	if weapon_change:
		print("loading res://Scenes/Weapons/weapon-%s.tscn" % glob_weapons.weapon_db[global.front_weapon]["res"])
		var weapon_node = load("res://Scenes/Weapons/weapon-%s.tscn" % glob_weapons.weapon_db[global.front_weapon]["res"])
		$Sprite2D/FrontWeaponPosition.add_child(weapon_node.instantiate())
	
	
	# rear weapon
	weapon_change = false
	if $Sprite2D/RearWeaponPosition.get_child_count() == 0:
		if global.rear_weapon != Enums.WeaponName.NONE:
			weapon_change = true
	else:
		if global.rear_weapon != $Sprite2D/RearWeaponPosition.get_child(0).weapon_name:
			$Sprite2D/RearWeaponPosition.get_child(0).queue_free()
			
			# if the weapon to change to is NONE, then there is no weapon to change
			if global.rear_weapon != Enums.WeaponName.NONE:
				weapon_change = true

	if weapon_change:
		var weapon_node = load("res://Scenes/Weapons/weapon-%s.tscn" % glob_weapons.weapon_db[global.rear_weapon]["res"])
		$Sprite2D/RearWeaponPosition.add_child(weapon_node.instantiate())

	
	# left weapon
	weapon_change = false
	if $Sprite2D/LeftWeaponPosition.get_child_count() == 0:
		if global.left_weapon != Enums.WeaponName.NONE:
			weapon_change = true
	else:
		if global.left_weapon != $Sprite2D/LeftWeaponPosition.get_child(0).weapon_name:
			$Sprite2D/LeftWeaponPosition.get_child(0).queue_free()
			
			# if the weapon to change to is NONE, then there is no weapon to change
			if global.left_weapon != Enums.WeaponName.NONE:
				weapon_change = true

	if weapon_change:
		var weapon_node = load("res://Scenes/Weapons/weapon-%s.tscn" % glob_weapons.weapon_db[global.left_weapon]["res"])
		$Sprite2D/LeftWeaponPosition.add_child(weapon_node.instantiate())
	

	# right weapon
	weapon_change = false
	if $Sprite2D/RightWeaponPosition.get_child_count() == 0:
		if global.right_weapon != Enums.WeaponName.NONE:
			weapon_change = true
	else:
		if global.right_weapon != $Sprite2D/RightWeaponPosition.get_child(0).weapon_name:
			$Sprite2D/RightWeaponPosition.get_child(0).queue_free()
			
			# if the weapon to change to is NONE, then there is no weapon to change
			if global.right_weapon != Enums.WeaponName.NONE:
				weapon_change = true

	if weapon_change:
		var weapon_node = load("res://Scenes/Weapons/weapon-%s.tscn" % glob_weapons.weapon_db[global.right_weapon]["res"])
		$Sprite2D/RightWeaponPosition.add_child(weapon_node.instantiate())

	# set weapons
	var firing : bool = in_store or Input.is_action_pressed("shoot")
	if $Sprite2D/FrontWeaponPosition.get_child_count() >= 1:
		$Sprite2D/FrontWeaponPosition.get_child(0).power = global.front_weapon_power
		$Sprite2D/FrontWeaponPosition.get_child(0).fire_when_ready = firing
	if $Sprite2D/RearWeaponPosition.get_child_count() >= 1:
		$Sprite2D/RearWeaponPosition.get_child(0).power = global.rear_weapon_power
		$Sprite2D/RearWeaponPosition.get_child(0).fire_when_ready = firing
	if $Sprite2D/LeftWeaponPosition.get_child_count() >= 1:
		$Sprite2D/LeftWeaponPosition.get_child(0).power = global.left_weapon_power
		$Sprite2D/LeftWeaponPosition.get_child(0).fire_when_ready = firing
	if $Sprite2D/RightWeaponPosition.get_child_count() >= 1:
		$Sprite2D/RightWeaponPosition.get_child(0).power = global.right_weapon_power
		$Sprite2D/RightWeaponPosition.get_child(0).fire_when_ready = firing
