extends Control

signal toMainMenu

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func set_score(value):
	$Panel/CurrentScore.text = "Current Score: " + str(value)



func _on_quit_button_pressed():
	toMainMenu.emit()
