extends Control

signal toMainMenu
signal restart

func _on_restart_button_pressed():
	restart.emit()

func set_score(value):
	$Panel/CurrentScore.text = "Current Score: " + str(value)



func _on_quit_button_pressed():
	toMainMenu.emit()
