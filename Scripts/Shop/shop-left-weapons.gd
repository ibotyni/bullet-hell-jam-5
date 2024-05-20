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
	seed(Protoship.datakeys_collected)
	global = get_node("/root/GlobalManager")
	glob_weapons = get_node("/root/Weapons")
	#if scene_manager.player:
		#add_child(scene_manager.player)
		#scene_manager.player.set_process(false)
		#scene_manager.player.set_physics_process(false)  # Disable player processing
		#scene_manager.player.visible = false  
		#print ("player received")
		
	player.global_position = Vector2(512, 224)
	player.visible = false

	CalcBuySellPrice()
	ShowBuySellPrice()

	if global.left_weapon == Enums.WeaponName.NONE:
		RandomizeStoreCard($ShopSlot1/Card)
		$ShopSlotNone.grab_focus()
		$Selection.position.y = 257
	else:
		$ShopSlot1/Card.weapon = global.left_weapon
		$ShopSlot1/Card.power_level = global.left_weapon_power
		$ShopSlot1.grab_focus()


	if (randf() > 0.25):
		RandomizeStoreCard($ShopSlot2/Card)
		$ShopSlot2.visible = true
	else:
		$ShopSlot2.visible = false
	if (randf() > 0.25):
		RandomizeStoreCard($ShopSlot3/Card)
		$ShopSlot3.visible = true
	else:
		$ShopSlot3.visible = false
	if (randf() > 0.25):
		RandomizeStoreCard($ShopSlot4/Card)
		$ShopSlot4.visible = true
	else:
		$ShopSlot4.visible = false



func RandomizeStoreCard(c):
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
	if next_price > Protoship.player_wallet:
		return

	Protoship.player_wallet -= next_price
	global.left_weapon_power += 1
	if global.left_weapon_power > 10:
		global.left_weapon_power = 10
	CalcBuySellPrice()
	ShowBuySellPrice()


func _on_power_down_pressed():
	Protoship.player_wallet += curr_price
	global.left_weapon_power -= 1
	if global.left_weapon_power < 1:
		global.left_weapon_power = 1
	CalcBuySellPrice()
	ShowBuySellPrice()


func _on_shop_slot_1_pressed():
	if $ShopSlot1/Card.price > Protoship.player_wallet + TotalPrice():
		return
		
	Protoship.player_wallet += TotalPrice()
	$Selection.position.y = 33
	global.left_weapon = $ShopSlot1/Card.weapon
	global.left_weapon_power = 1
	CalcBuySellPrice()
	Protoship.player_wallet -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_2_pressed():
	if $ShopSlot2/Card.price > Protoship.player_wallet + TotalPrice():
		return
	
	Protoship.player_wallet += TotalPrice()
	$Selection.position.y = 89
	global.left_weapon = $ShopSlot2/Card.weapon
	global.left_weapon_power = 1
	CalcBuySellPrice()
	Protoship.player_wallet -= curr_price
	ShowBuySellPrice()


func _on_shop_slot_3_pressed():
	if $ShopSlot3/Card.price > Protoship.player_wallet + TotalPrice():
		return
		
	Protoship.player_wallet += TotalPrice()
	$Selection.position.y = 145
	global.left_weapon = $ShopSlot3/Card.weapon
	global.left_weapon_power = 1
	CalcBuySellPrice()
	Protoship.player_wallet -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_4_pressed():
	if $ShopSlot4/Card.price > Protoship.player_wallet + TotalPrice():
		return
		
	Protoship.player_wallet += TotalPrice()
	$Selection.position.y = 201
	global.left_weapon = $ShopSlot4/Card.weapon
	global.left_weapon_power = 1
	CalcBuySellPrice()
	Protoship.player_wallet -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_none_pressed():
	Protoship.player_wallet += TotalPrice()
	$Selection.position.y = 257
	global.left_weapon = Enums.WeaponName.NONE
	global.left_weapon_power = 1
	CalcBuySellPrice()
	ShowBuySellPrice()


func CalcBuySellPrice():
	prev_price = CalcPrice(global.left_weapon, global.left_weapon_power - 1)
	curr_price = CalcPrice(global.left_weapon, global.left_weapon_power)
	next_price = CalcPrice(global.left_weapon, global.left_weapon_power + 1)

func CalcPrice(weapon, power_level):
	if weapon == Enums.WeaponName.NONE:
		return 0

	var w: Dictionary = glob_weapons.weapon_db[weapon]
	return roundi( pow( power_level, 1.75 ) * w.price / 100 ) * 100

func ShowBuySellPrice():
	$Wallet.text = "Current Funds: %d" % Protoship.player_wallet
	if global.left_weapon == Enums.WeaponName.NONE:
		$PowerLevel.text = ""
		$SellPrice.text = ""
		$BuyPrice.text = ""
		$"Power-Down".visible = false
		$"Power-Up".visible = false
	else:
		$PowerLevel.text = "Power: %d" % global.left_weapon_power
		$SellPrice.text = str( prev_price )
		$BuyPrice.text = str( next_price )
		$"Power-Down".visible = global.left_weapon_power != 1
		$"Power-Up".visible = global.left_weapon_power != 10


func TotalPrice():
	if global.left_weapon == Enums.WeaponName.NONE:
		return 0
		
	var total = 0
	for i in range(1, global.left_weapon_power + 1):
		total += CalcPrice(global.left_weapon, i)
	return total



func _on_done_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop.tscn")
	
