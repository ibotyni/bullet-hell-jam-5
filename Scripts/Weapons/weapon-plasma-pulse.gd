extends Node2D

var global : Node
var glob_weapons : Node

var weapon_name : Enums.WeaponName = Enums.WeaponName.PLASMA_PULSE
var weapon
var base_damage = 1
var total_damage = 1

var projectile = load("res://Scenes/Weapons/Projectiles/plasma-pulse.tscn")

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
	if $Cooldown.wait_time <= 0:
		$Cooldown.wait_time = 0.0001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot():
	if not $Cooldown.is_stopped():
		return
		
	var bullet = projectile.instatiate()
	bullet.damage = total_damage
	# Set the bullet's position and rotation 
	bullet.global_position = self.global_position
	bullet.rotation = self.global_rotation

	# Add the bullet to the scene tree
	get_parent().get_parent().add_child(bullet)
	
	$Cooldown.start()
	
	if not mute_sfx:
		$ShootingSFX.play()
