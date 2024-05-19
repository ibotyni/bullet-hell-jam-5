extends Node

var cash = 0  # Only storing cash now
var front_weapon : Enums.WeaponName = Enums.WeaponName.PLASMA_PULSE
var front_weapon_power : int = 1
var rear_weapon : Enums.WeaponName = Enums.WeaponName.PLASMA_PULSE
var rear_weapon_power : int = 1
var left_weapon : Enums.WeaponName = Enums.WeaponName.PLASMA_PULSE
var left_weapon_power : int = 1
var right_weapon : Enums.WeaponName = Enums.WeaponName.PLASMA_PULSE
var right_weapon_power : int = 1
var ship_type : Enums.ShipType = Enums.ShipType.MINAHASA

var player = Protoship
@onready var player_data = Protoship.get_script()

func _ready():
	seed(0)
	load_game()

func load_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		var json = JSON.new()
		var error = json.parse(save_file.get_as_text())
		if error == OK:
			var save_data = json.get_data()
			cash = save_data.get("cash", 10000)  # Default to 100 if not found
		else:
			print("Error parsing save data:", error)
	else:
		reset_game_data()

func save_game():
	var save_data = {
		"cash": cash
	}
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))

func reset_game_data():
	cash = 10000
	save_game()
