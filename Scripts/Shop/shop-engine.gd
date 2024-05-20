extends Node2D

var global : Node
var glob_db : Node

var curr_price : int = 0

var player = Protoship
@onready var player_data = Protoship.get_script()

# Called when the node enters the scene tree for the first time.
func _ready():
	seed(Protoship.datakeys_collected)
	global = get_node("/root/GlobalManager")
	glob_db = get_node("/root/Weapons")
	#if scene_manager.player:
		#add_child(scene_manager.player)
		#scene_manager.player.set_process(false)
		#scene_manager.player.set_physics_process(false)  # Disable player processing
		#scene_manager.player.visible = false  
		#print ("player received")
		
	player.visible = false
	

	CalcBuySellPrice()
	ShowBuySellPrice()

	$ShopSlot1/Card.engine = global.engine
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func RandomizeStoreCard(c):
	var glob_db = get_node("/root/Weapons")
	var lucky_dip = []

	for w in glob_db.engine_db.keys():
		for i in range(glob_db.engine_db[w]["rarity pct"]):
			lucky_dip.append(w)

	var selected = lucky_dip[ randi_range(0, len(lucky_dip)-1 ) ]
	c.engine = selected

func _on_protoship_bullet_shot(bullet_scene, location):
	var bullet = bullet_scene.instantiate() 
	bullet.global_position = location
	$ProjectileContainer.add_child(bullet)


func _on_shop_slot_1_pressed():
	if $ShopSlot1/Card.price > Protoship.player_wallet + curr_price:
		return
		
	Protoship.player_wallet += curr_price
	$Selection.position.y = 33
	global.engine = $ShopSlot1/Card.engine
	global.max_speed = $ShopSlot1/Card.speed
	CalcBuySellPrice()
	Protoship.player_wallet -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_2_pressed():
	if $ShopSlot2/Card.price > Protoship.player_wallet + curr_price:
		return
	
	Protoship.player_wallet += curr_price
	$Selection.position.y = 89
	global.engine = $ShopSlot2/Card.engine
	global.max_speed = $ShopSlot2/Card.speed
	CalcBuySellPrice()
	Protoship.player_wallet -= curr_price
	ShowBuySellPrice()


func _on_shop_slot_3_pressed():
	if $ShopSlot3/Card.price > Protoship.player_wallet + curr_price:
		return
		
	Protoship.player_wallet += curr_price
	$Selection.position.y = 145
	global.engine = $ShopSlot3/Card.engine
	global.max_speed = $ShopSlot3/Card.speed
	CalcBuySellPrice()
	Protoship.player_wallet -= curr_price
	ShowBuySellPrice()

func _on_shop_slot_4_pressed():
	if $ShopSlot4/Card.price > Protoship.player_wallet + curr_price:
		return
		
	Protoship.player_wallet += curr_price
	$Selection.position.y = 201
	global.engine = $ShopSlot4/Card.engine
	global.max_speed = $ShopSlot4/Card.speed
	CalcBuySellPrice()
	Protoship.player_wallet -= curr_price
	ShowBuySellPrice()


func CalcBuySellPrice():
	var w: Dictionary = glob_db.engine_db[global.engine]
	curr_price = w.price


func ShowBuySellPrice():
	$Wallet.text = "Current Funds: %d" % Protoship.player_wallet
	$PowerLevel.text = "Speed: %d" % glob_db.engine_db[global.engine].speed



func _on_done_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop.tscn")
	
