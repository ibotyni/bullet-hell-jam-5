extends Control

@export var ship_type: Enums.ShipType = Enums.ShipType.MINAHASA
var prev_ship_type: Enums.ShipType = Enums.ShipType.MINAHASA

var price: int = 0
var armour: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SetCard()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ship_type != prev_ship_type:
		SetCard()

func SetCard():
	var glob_db = get_node("/root/Weapons")
	var s: Dictionary = glob_db.ship_type_db[ship_type]
	
	price = s.price
	armour = s.armour
	
	$icon.texture = load("res://Assets/Artwork/Ships/%s.png" % s.res)
	$Title.text = s.name
	$Level.text = "Price: %d" % price

	prev_ship_type = ship_type
