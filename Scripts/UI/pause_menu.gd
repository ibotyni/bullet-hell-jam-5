extends CanvasLayer

signal redirect_quit 
signal game_unpaused  # New signal for when the game is unpaused

func _on_continue_button_pressed():
	self.visible = false
	get_tree().paused = false
	self.set_process(false)
	game_unpaused.emit()

func _on_menu_pressed():
	self.visible = false
	redirect_quit.emit()

#Old Restart Function func _on_menu_pressed():
	#self.visible = false
	#get_tree().paused = false
	#get_tree().reload_current_scene()
	#self.set_process(false)
