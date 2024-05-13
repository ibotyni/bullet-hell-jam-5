extends Node

var cash = 0
var high_score = 0  # Declare high_score here


func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		var json = JSON.new()
		var error = json.parse(save_file.get_as_text()) 
		if error == OK:  # Check for successful parsing
			var save_data = json.get_data()
			cash = save_data.get("cash", 100)
			high_score = save_data.get("high_score", 0)
		else:
			print("Error parsing save data:", error) 
	else:
		cash = 100
		high_score = 0
		save_game()


func save_game():
	var save_data = {
		"high_score": high_score,
		"cash": cash
	}
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))  # Call stringify directly on JSON
