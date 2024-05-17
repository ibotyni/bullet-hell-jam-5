extends Control

@export var power_level : int = 1:
	set(value):
		if value < 1:
			value = 1
		elif value > 10:
			value = 10
		power_level = value
var prev_power_level : int = 1

@export var weapon: Enums.WeaponName = Enums.WeaponName.PLASMA_PULSE
var prev_weapon: Enums.WeaponName = Enums.WeaponName.PLASMA_PULSE

@export var price: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SetCard()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if power_level != prev_power_level or weapon != prev_weapon:
		SetCard()

func SetCard():
	var glob_weapons = get_node("/root/Weapons")
	var w: Dictionary = glob_weapons.weapon_db[weapon]
	
	var col := "00ff00"
	match w.rarity:
		"Uncommon":
			col = "0000ff"
		"Rare":
			col = "592a9c"
		"Epic":
			col = "ff0000"
		"Legendary":
			col = "ffd700"
			
	price = roundi( pow( power_level, 1.75 ) * w.price / 100 ) * 100
	
	$"card-frame".material.set_shader_parameter("custom_color", Color(col))
	$icon.texture = load("res://Assets/Artwork/weapons/%s.png" % w.res)
	$Title.text = w.name
	$Level.text = "Price: %d" % price

	prev_power_level = power_level
	prev_weapon = weapon
