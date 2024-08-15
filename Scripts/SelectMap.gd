extends Control



func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu3D.tscn")


func _on_forest_track_pressed():
	GameData.selected_map = "res://Scenes/world.tscn"
	get_tree().change_scene_to_file("res://Scenes/select_car.tscn")


func _on_desert_track_pressed():
	GameData.selected_map = "res://Scenes/world_2.tscn"
	get_tree().change_scene_to_file("res://Scenes/select_car.tscn")


func _on_freeroam_pressed():
	GameData.selected_map = "res://Scenes/world_3.tscn"
	get_tree().change_scene_to_file("res://Scenes/select_car.tscn")
