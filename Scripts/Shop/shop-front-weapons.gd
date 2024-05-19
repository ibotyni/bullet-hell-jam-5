extends Node2D

var global : Node
var glob_weapons : Node

var prev_price : int = 0
var curr_price : int = 0
var next_price : int = 0

var player = Protoship
@onready var player_data = Protoship.get_script()

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/GlobalManager")
	glob_weapons = get_node("/root/Weapons")
	#if scene_manager.player:
		#add_child(scene_manager.player)
		#scene_manager.player.set_process(false)
		#scene_manager.player.set_physics_process(false)  # Disable player processing
		#scene_manager.player.visible = false  
		#print ("player received")

	CalcBuySellPrice()
	ShowBuySellPrice()

	if global.front_weapon == Enums.WeaponName.NONE:
		RandomizeStoreCard($ShopSlot1/Card)
	else:
		$ShopSlot1/Card.weapon = global.front_weapon
		$ShopSlot1/Card.power_level = global.front_weapon_power

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
	global.front_weapon_power += 1
	if global.front_weapon_power > 10:
		global.front_weapon_power = 10
	CalcBuySellPrice()
	ShowBuySellPrice()


func _on_power_down_pressed():
	global.cash += curr_price
	global.front_weapon_power -= 1
	if global.front_weapon_power < 1:
		global.front_weapon_power = 1
	CalcBuySellPrice()
	ShowBuySellPrice()


func _on_shop_slot_1_pressed():
	if $ShopSlot1/Card.price > global.cash + TotalPrice():
		return
		
	global.cash += TotalPrice()
	$Selection.position.y = 40
	global.front_weapon = $ShopSlot1/Card.weapon
	global.front_weapon_power = 1
	CalcBuySellPrice()
	global.cash -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_2_pressed():
	if $ShopSlot2/Card.price > global.cash + TotalPrice():
		return
	
	global.cash += TotalPrice()
	$Selection.position.y = 112
	global.front_weapon = $ShopSlot2/Card.weapon
	global.front_weapon_power = 1
	CalcBuySellPrice()
	global.cash -= curr_price
	ShowBuySellPrice()


func _on_shop_slot_3_pressed():
	if $ShopSlot3/Card.price > global.cash + TotalPrice():
		return
		
	global.cash += TotalPrice()
	$Selection.position.y = 184
	global.front_weapon = $ShopSlot3/Card.weapon
	global.front_weapon_power = 1
	CalcBuySellPrice()
	global.cash -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_4_pressed():
	if $ShopSlot4/Card.price > global.cash + TotalPrice():
		return
		
	global.cash += TotalPrice()
	$Selection.position.y = 256
	global.front_weapon = $ShopSlot4/Card.weapon
	global.front_weapon_power = 1
	CalcBuySellPrice()
	global.cash -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_none_pressed():
	global.cash += TotalPrice()
	$Selection.position.y = 256
	global.front_weapon = Enums.WeaponName.NONE
	global.front_weapon_power = 1
	CalcBuySellPrice()
	ShowBuySellPrice()


func CalcBuySellPrice():
	prev_price = CalcPrice(global.front_weapon, global.front_weapon_power - 1)
	curr_price = CalcPrice(global.front_weapon, global.front_weapon_power)
	next_price = CalcPrice(global.front_weapon, global.front_weapon_power + 1)

func CalcPrice(weapon, power_level):
	if weapon == Enums.WeaponName.NONE:
		return 0

	var w: Dictionary = glob_weapons.weapon_db[weapon]
	return roundi( pow( power_level, 1.75 ) * w.price / 100 ) * 100

func ShowBuySellPrice():
	$Wallet.text = "Current Funds: %d" % global.cash
	if global.front_weapon == Enums.WeaponName.NONE:
		$PowerLevel.text = ""
		$SellPrice.text = ""
		$BuyPrice.text = ""
		$"Power-Down".visible = false
		$"Power-Up".visible = false
	else:
		$PowerLevel.text = "Power: %d" % global.front_weapon_power
		$SellPrice.text = str( prev_price )
		$BuyPrice.text = str( next_price )
		$"Power-Down".visible = global.front_weapon_power != 1
		$"Power-Up".visible = global.front_weapon_power != 10


func TotalPrice():
	if global.front_weapon == Enums.WeaponName.NONE:
		return 0
		
	var total = 0
	for i in range(1, global.front_weapon_power + 1):
		total += CalcPrice(global.front_weapon, i)
	return total



func _on_done_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop.tscn")
	
