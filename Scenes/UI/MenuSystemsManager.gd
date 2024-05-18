extends CanvasLayer

@onready var MainMenu = $MainMenu
@onready var SettingsMenu = $"Settings Menu"
@onready var Credits = $Credits
@onready var confirmation = $"Confirm New Game"
@onready var confirm_quit = $ConfirmQuit

func _ready():
	MainMenu.visible = true
	MainMenu.set_process(true)
	SettingsMenu.visible = false
	SettingsMenu.set_process(false)
	Credits.visible = false
	Credits.set_process(false)
	confirmation.visible = false
	confirmation.set_process(false)
	confirm_quit.set_process(false)
	confirm_quit.visible = false

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
	GlobalManager.reset_game_data()
	get_tree().change_scene_to_file("res://Scenes/Levels/galaxy_map.tscn")

func _on_load_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/galaxy_map.tscn")

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

#Quit


func _on_quit_pressed():
	MainMenu.set_process(false)
	MainMenu.visible = false 
	confirm_quit.set_process(true)
	confirm_quit.visible = true
	
func _on_quit_yes_button_pressed():
	get_tree().quit()

func _on_quit_no_button_pressed():
	confirm_quit.set_process(false)
	confirm_quit.visible = false
	MainMenu.set_process(true)
	MainMenu.visible = true 




