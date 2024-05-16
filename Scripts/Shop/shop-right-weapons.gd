extends Node2D

var global : Node
var glob_weapons : Node

var prev_price : int = 0
var curr_price : int = 0
var next_price : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/GlobalManager")
	glob_weapons = get_node("/root/Weapons")

	CalcBuySellPrice()
	ShowBuySellPrice()

	$ShopSlot1/Card.weapon = global.right_weapon
	$ShopSlot1/Card.power_level = global.right_weapon_power

	if (randf() > 0.5):
		RandomizeStoreCard($ShopSlot2/Card)
		$ShopSlot2.visible = true
	else:
		$ShopSlot2.visible = false
	if (randf() > 0.5):
		RandomizeStoreCard($ShopSlot3/Card)
		$ShopSlot3.visible = true
	else:
		$ShopSlot3.visible = false
	if (randf() > 0.5):
		RandomizeStoreCard($ShopSlot4/Card)
		$ShopSlot4.visible = true
	else:
		$ShopSlot4.visible = false

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
	c.power_level = 1

func _on_protoship_bullet_shot(bullet_scene, location):
	var bullet = bullet_scene.instantiate() 
	bullet.global_position = location
	$ProjectileContainer.add_child(bullet)


func _on_power_up_pressed():
	if next_price > global.cash:
		return

	global.cash -= next_price
	global.right_weapon_power += 1
	if global.right_weapon_power > 10:
		global.right_weapon_power = 10
	CalcBuySellPrice()
	ShowBuySellPrice()



func _on_power_down_pressed():
	global.cash += curr_price
	global.right_weapon_power -= 1
	if global.right_weapon_power < 1:
		global.right_weapon_power = 1
	CalcBuySellPrice()
	ShowBuySellPrice()


func _on_shop_slot_1_pressed():
	if $ShopSlot1/Card.price > global.cash + TotalPrice():
		return
		
	global.cash += TotalPrice()
	$Selection.position.y = 40
	global.right_weapon = $ShopSlot1/Card.weapon
	global.right_weapon_power = 1
	CalcBuySellPrice()
	global.cash -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_2_pressed():
	if $ShopSlot2/Card.price > global.cash + TotalPrice():
		return
	
	global.cash += TotalPrice()
	$Selection.position.y = 112
	global.right_weapon = $ShopSlot2/Card.weapon
	global.right_weapon_power = 1
	CalcBuySellPrice()
	global.cash -= curr_price
	ShowBuySellPrice()


func _on_shop_slot_3_pressed():
	if $ShopSlot3/Card.price > global.cash + TotalPrice():
		return
		
	global.cash += TotalPrice()
	$Selection.position.y = 184
	global.right_weapon = $ShopSlot3/Card.weapon
	global.right_weapon_power = 1
	CalcBuySellPrice()
	global.cash -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_4_pressed():
	if $ShopSlot4/Card.price > global.cash + TotalPrice():
		return
		
	global.cash += TotalPrice()
	$Selection.position.y = 256
	global.right_weapon = $ShopSlot4/Card.weapon
	global.right_weapon_power = 1
	CalcBuySellPrice()
	global.cash -= curr_price
	ShowBuySellPrice()


func CalcBuySellPrice():
	prev_price = CalcPrice(global.right_weapon, global.right_weapon_power - 1)
	curr_price = CalcPrice(global.right_weapon, global.right_weapon_power)
	next_price = CalcPrice(global.right_weapon, global.right_weapon_power + 1)

func ShowBuySellPrice():
	$Wallet.text = "Current Funds: %d" % global.cash
	$PowerLevel.text = "Power: %d" % global.right_weapon_power
	$SellPrice.text = str( prev_price )
	$BuyPrice.text = str( next_price )
	
	$"Power-Down".visible = global.right_weapon_power != 1
	$"Power-Up".visible = global.right_weapon_power != 10

func CalcPrice(weapon, power_level):
	var w: Dictionary = glob_weapons.weapon_db[weapon]
	return roundi( pow( power_level, 1.75 ) * w.price / 100 ) * 100

func TotalPrice():
	var total = 0
	for i in range(1, global.right_weapon_power + 1):
		total += CalcPrice(global.right_weapon, i)
	return total
