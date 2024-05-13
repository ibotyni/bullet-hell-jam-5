extends Node2D

var shop_item = []

# Called when the node enters the scene tree for the first time.
func _ready():
	RandomizeStoreCard($Card)
	RandomizeStoreCard($Card2)
	RandomizeStoreCard($Card3)
	RandomizeStoreCard($Card4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func RandomizeStoreCard(c):
	var glob_weapons = get_node("/root/Weapons")
	var lucky_dip = []

	for w in glob_weapons.weapon_db.keys():
		for i in range(glob_weapons.weapon_db[w]["rarity pct"]):
			lucky_dip.append(w)

	var selected_weapon = lucky_dip[ randi_range(0, len(lucky_dip)-1 ) ]

	c.weapon = selected_weapon
	c.power_level = randi_range(0,10)


func _on_power_up_pressed():
	$WeaponEquipped1.power_level += 1


func _on_power_down_pressed():
	$WeaponEquipped1.power_level -= 1
