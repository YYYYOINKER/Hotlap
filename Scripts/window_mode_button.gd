extends Control

@onready var options_button = $HBoxContainer/OptionButton as OptionButton
var settings_file = "user://video_settings2.cfg"
var config = ConfigFile.new()

const WINDOW_MODE_ARRAY: Array[String] = [
	"Full-Screen",
	"Windowed Mode",
	"Borderless Mode",
	"Borderless-Full-Screen"
]

func _ready():
	add_window_mode_items()
	load_settings()  # Load the window mode setting
	options_button.connect("item_selected", Callable(self, "on_window_mode_selected"))

func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		options_button.add_item(window_mode)

func on_window_mode_selected(index: int) -> void:
	set_window_mode(index)
	save_settings()  # Save the window mode setting

func set_window_mode(index: int) -> void:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Borderless Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # Borderless-Full-Screen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func save_settings():
	config.set_value("video", "window_mode", options_button.selected)
	config.save(settings_file)

func load_settings():
	var error = config.load(settings_file)
	if error != OK:
		print("Settings not found, using defaults.")
		set_window_mode(0)  # Default to Full-Screen
	else:
		var mode = config.get_value("video", "window_mode", 0)
		options_button.selected = mode
		set_window_mode(mode)
		
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
