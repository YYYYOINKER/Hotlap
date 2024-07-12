extends Control

func _process(_delta):
	MusicController.play_music()
	get_tree().change_scene_to_file("res://Scenes/MainMenu3D.tscn")


