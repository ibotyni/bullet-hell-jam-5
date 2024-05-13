extends CanvasLayer

@onready var MainMenu = $MainMenu
@onready var SettingsMenu = $"Settings Menu"
@onready var Credits = $Credits
@onready var confirmation = $"Confirm New Game"

func _ready():
	MainMenu.visible = true
	MainMenu.set_process(true)
	SettingsMenu.visible = false
	SettingsMenu.set_process(false)
	Credits.visible = false
	Credits.set_process(false)
	confirmation.visible = false
	confirmation.set_process(false)

#New Game
func _on_no_button_pressed():
	confirmation.visible = false
	confirmation.set_process(false)
	MainMenu.visible = true 
	MainMenu.set_process(true)



func _on_new_game_pressed():
	MainMenu.visible = false 
	MainMenu.set_process(false)
	confirmation.visible = true
	confirmation.set_process(true)

func _on_yes_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/test_hell.tscn")

func _on_load_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/test_hell.tscn")

#Settings
func _on_settings_pressed():
	MainMenu.visible = false 
	MainMenu.set_process(false)
	SettingsMenu.visible = true
	SettingsMenu.set_process(true)

func _on_back_button_settings_pressed():
	SettingsMenu.visible = false
	SettingsMenu.set_process(false)
	MainMenu.visible = true 
	MainMenu.set_process(true)


#Credits

func _on_credits_pressed():
	MainMenu.visible = false 
	MainMenu.set_process(false)
	Credits.visible = true
	Credits.set_process(true)

func _on_back_button_credits_pressed():
	Credits.visible = false
	Credits.set_process(false)
	MainMenu.visible = true 
	MainMenu.set_process(true)








