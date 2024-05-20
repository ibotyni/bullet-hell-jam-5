extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Protoship.visible = false
	$lblMoola.text = str( Protoship.player_wallet )
	$btnShipType.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_front_weapon_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop-front-weapons.tscn")


func _on_btn_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/galaxy_map.tscn")


func _on_btn_rear_weapon_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop-rear-weapons.tscn")


func _on_btn_left_weapon_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop-left-weapons.tscn")


func _on_btn_right_weapon_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop-right-weapons.tscn")


func _on_btn_ship_type_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop-ship-type.tscn")


func _on_btn_engine_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop-engine.tscn")
