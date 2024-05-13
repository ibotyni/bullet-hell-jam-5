extends Node

var cash = 0 


func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!=null:
		cash = save_file.get_32()
		print ("Save Found")
	else:
		cash = 100
		save_game()


func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(cash)

