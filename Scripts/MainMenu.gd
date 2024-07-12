extends Control

func _ready():
	# Reset selections when the main menu is ready
	GameData.selected_map = ""
	GameData.selected_car = ""

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/select_map.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()

#top times
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/best_lap_scene.tscn")
