extends Control

@export var power_level : int = 1:
	set(value):
		if value < 1:
			value = 1
		elif value > 10:
			value = 10
		power_level = value

#	Common		green
#	Uncommon	blue
#	Rare		purple
#	Epic		red
#	Legendary	golden

@export_enum(
	"Plasma Pulse",
	"Neutrino Shot",
	"Draxian Pulse",
	"Vulkan Cannon",
	"Thra'gul Mines", 
	"Mega Blast", 
	"Chronon Blast",
	"Ion Disruptor", 
	"Zorthian Laser") var Weapon: String

@export var weapon_db = {
	"Plasma Pulse": {"rarity pct": 80, "rarity": "Common", "res": "pulse", "colour": "ffd700", "base rate": 1.0, "level rate": 0.1, "damage":1, "price":500 },
	"Neutrino Shot": {"rarity pct": 70, "rarity": "Common", "res": "shot", "colour": "d7d7ff", "base rate": 0.5, "level rate": 0.05, "damage":2, "price":1600},
	"Vulkan Cannon": {"rarity pct": 60, "rarity": "Uncommon", "res": "shot", "colour": "ffd700", "base rate": 0.1, "level rate": 0.005, "damage":1, "price":1000 },
	"Draxian Pulse": {"rarity pct": 50, "rarity": "Uncommon", "res": "pulse", "colour": "00d730", "base rate": 0.75, "level rate": 0.075, "damage":1, "price":900 },
	"Thra'gul Mines": {"rarity pct": 40, "rarity": "Rare", "res": "mines", "colour": "ff0000", "base rate": 5.0, "level rate": 0.5, "damage":10, "price":200 },
	"Mega Blast": {"rarity pct": 30, "rarity": "Rare", "res": "blast", "colour": "ffd700", "base rate": 1, "level rate": 0.075, "damage":4, "price":1000 },
	"Chronon Blast": {"rarity pct": 10, "rarity": "Epic", "res": "blast", "colour": "ffd7ff", "base rate": 0.2, "level rate": 0.025, "damage":5, "price":2000 },
	"Ion Disruptor": {"rarity pct": 10, "rarity": "Epic", "res": "ion", "colour": "ffd7ff", "base rate": 0.2, "level rate": 0.025, "damage":5, "price":2000 },
	"Zorthian Laser": {"rarity pct": 2, "rarity": "Legendary", "res": "laser", "colour": "ffff50", "base rate": 0.05, "level rate": 0.005, "damage":8, "price":5000 }
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var w: Dictionary = weapon_db[Weapon]
	
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
	
	$"card-frame".material.set_shader_parameter("custom_color", Color(col))
	
	# weakest power is yellow, strongest is red
	#var yellowness : float = ((5-power_level) * 50.0) / 255

	#$"card-frame/icon".texture = load("res://Assets/Artwork/bullets/pulse-%02d.png" % power_level)
	$"card-frame/icon".texture = load("res://Assets/Artwork/bullets/%s.png" % w.res)
	$"card-frame/icon".material.set_shader_parameter("custom_color", Color(w.colour))
	$"card-frame/Title".text = Weapon
	$"card-frame/Level".text = "Level:%d\nPrice:%d" % [power_level, roundi( pow( power_level, 1.75 ) * w.price / 100 ) * 100 ]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
