extends Control

func _on_video_pressed():
	get_tree().change_scene_to_file("res://Scenes/video_menu.tscn")


func _on_audio_pressed():
	get_tree().change_scene_to_file("res://Scenes/audio_menu.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu3D.tscn")
