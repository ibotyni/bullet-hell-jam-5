class_name SceneManager extends Node


var player: Player

var scene_direct_path = "res://Scenes/Levels"



func change_scene(from, to_scene_name: String) -> void:
	player = from.player
	player.get_parent().remove_child(player)
	
	var full_path = scene_direct_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
