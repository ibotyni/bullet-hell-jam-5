extends Node2D

var global : Node
var glob_weapons : Node

@export var weapon_name : Enums.WeaponName = Enums.WeaponName.DRAXIAN_PULSE
var weapon
var base_damage = 1
var total_damage = 1

@export var fire_when_ready: bool = false

var projectile = preload("res://Scenes/Weapons/Projectiles/draxian-pulse.tscn")

@export var mute_sfx : bool = false

@export var power : int = 1:
	set(new_power):
		power = new_power
		total_damage = power * base_damage


# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/GlobalManager")
	glob_weapons = get_node("/root/Weapons")
	
	weapon = glob_weapons.weapon_db[weapon_name]
	$Cooldown.wait_time = weapon["base rate"] - (weapon["level rate"] * (power - 1) )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Cooldown.is_stopped() or $Cooldown.wait_time <= 0:
		shoot()

func shoot():
	if not fire_when_ready:
		return

	var bullet_front = projectile.instantiate()
	bullet_front.damage = total_damage
	bullet_front.rotation = 0
	add_child(bullet_front)
	var bullet_left = projectile.instantiate()
	bullet_left.damage = total_damage
	bullet_left.rotation = -45
	add_child(bullet_left)
	var bullet_right = projectile.instantiate()
	bullet_right.damage = total_damage
	bullet_right.rotation = 45
	add_child(bullet_right)

	$Cooldown.wait_time = weapon["base rate"] - (weapon["level rate"] * (power - 1) )
	
	if $Cooldown.wait_time > 0:
		$Cooldown.start()
	if not mute_sfx:
		$ShootingSFX.play()
