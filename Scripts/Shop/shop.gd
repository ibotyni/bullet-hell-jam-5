extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_front_weapon_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop-front-weapons.tscn")


func _on_btn_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/galaxy_map.tscn")
