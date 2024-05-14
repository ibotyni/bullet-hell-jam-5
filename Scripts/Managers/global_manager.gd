extends Node

var cash = 0  # Only storing cash now

func _ready():
	load_game()

func load_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		var json = JSON.new()
		var error = json.parse(save_file.get_as_text())
		if error == OK:
			var save_data = json.get_data()
			cash = save_data.get("cash", 100)  # Default to 100 if not found
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
	cash = 100
	save_game()
