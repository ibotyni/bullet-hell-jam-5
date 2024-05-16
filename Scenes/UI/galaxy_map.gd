class_name GalaxyMap extends Node

@onready var corner_buttons: Control = $"UI/Control/Corner Buttons"
@onready var settings_menu: Control = $"UI/Settings Menu"

func _ready():
	corner_buttons.visible = true
	corner_buttons.set_process(true)
	settings_menu.visible = false
	settings_menu.set_process(false)
	if scene_manager.player:
		add_child(scene_manager.player)
		scene_manager.player.set_process(false)
		scene_manager.player.set_physics_process(false)  # Disable player processing
		scene_manager.player.visible = false  
		print ("player received")

func _on_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/MainMenu/main_menu_scene.tscn")








func _on_settings_pressed():
	corner_buttons.visible = false 
	corner_buttons.set_process(false)
	settings_menu.visible = true
	settings_menu.set_process(true)

func _on_back_button_settings_pressed():
	settings_menu.visible = false
	settings_menu.set_process(false)
	corner_buttons.visible = true
	corner_buttons.set_process(true)


func _on_to_garage_pressed():
	pass # Replace with function body.


