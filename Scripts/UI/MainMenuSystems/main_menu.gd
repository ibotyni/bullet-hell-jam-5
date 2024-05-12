extends Control

signal settings_pressed



func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/test_hell.tscn")



func _on_settings_pressed():
	settings_pressed.emit()
