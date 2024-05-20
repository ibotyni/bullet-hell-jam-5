extends Control

var engine: Enums.EngineName = Enums.EngineName.FURO
var prev_engine: Enums.EngineName = Enums.EngineName.FURO

var price: int = 0
var speed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SetCard()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if engine != prev_engine:
		SetCard()

func SetCard():
	var glob_db = get_node("/root/Weapons")
	var s: Dictionary = glob_db.engine_db[engine]
	
	price = s.price
	speed = s.speed
	
	$icon.texture = load("res://Assets/Artwork/engines/%s.png" % s.res)
	$Title.text = s.name
	$Level.text = "Price: %d" % price

	prev_engine = engine
