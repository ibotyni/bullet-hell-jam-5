extends CanvasLayer

signal redirect_quit

func _on_continue_button_pressed():
	self.visible = false
	get_tree().paused = false
	self.set_process(false)

func _on_menu_pressed():
	self.visible = false
	redirect_quit.emit()
	

#Old Restart Function func _on_menu_pressed():
	#self.visible = false
	#get_tree().paused = false
	#get_tree().reload_current_scene()
	#self.set_process(false)
