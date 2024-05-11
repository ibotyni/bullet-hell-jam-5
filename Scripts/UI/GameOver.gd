extends Control

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func set_score(value):
	$Panel/CurrentScore.text = "Current Score: " + str(value)

func set_high_score(value):
	$Panel/HighScore.text = "High Score: " + str(value)
