extends Node

var menu_music = load("res://Sounds/Music/Sunshine In Your Eyes.mp3")

func _ready():
	pass
	
func play_music():
	$MusicStreamPlayer.stream = menu_music
	$MusicStreamPlayer.play()
