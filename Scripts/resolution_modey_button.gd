extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton
var settings_file = "user://video_settings.cfg"
var config = ConfigFile.new()

const RESOLUTION_OPTIONS = ["1920 x 1080", "1600 x 900", "1280 x 720", "1152 x 648"]
const RESOLUTION_DICTIONARY: Dictionary = {
	"1920 x 1080": Vector2i(1920, 1080),
	"1600 x 900": Vector2i(1600, 900),
	"1280 x 720": Vector2i(1280, 720),
	"1152 x 648": Vector2i(1152, 648),
}

func _ready():
	add_resolution_items()
	load_settings()
	option_button.connect("item_selected", Callable(self, "on_resolution_selected"))

func add_resolution_items() -> void:
	for resolution in RESOLUTION_OPTIONS:
		option_button.add_item(resolution)

func on_resolution_selected(index: int) -> void:
	if index >= 0 and index < RESOLUTION_OPTIONS.size():
		var resolution_key = RESOLUTION_OPTIONS[index]
		set_resolution(resolution_key)
		save_settings()
	else:
		print("Invalid resolution index: ", index)

func set_resolution(resolution_key: String) -> void:
	if resolution_key in RESOLUTION_DICTIONARY:
		var resolution = RESOLUTION_DICTIONARY[resolution_key]
		DisplayServer.window_set_size(resolution)
	else:
		print("Invalid resolution key: ", resolution_key)

func save_settings():
	if option_button.selected >= 0 and option_button.selected < RESOLUTION_OPTIONS.size():
		var selected_resolution = RESOLUTION_OPTIONS[option_button.selected]
		config.set_value("video", "resolution", selected_resolution)
		config.save(settings_file)
	else:
		print("Trying to save an invalid resolution selection")

func load_settings():
	var error = config.load(settings_file)
	if error != OK:
		print("Settings not found, using defaults.")
		option_button.selected = 0
		set_resolution(RESOLUTION_OPTIONS[0])
	else:
		var resolution_key = config.get_value("video", "resolution", RESOLUTION_OPTIONS[0])
		var index = RESOLUTION_OPTIONS.find(resolution_key)
		if index != -1:
			option_button.selected = index
			set_resolution(resolution_key)
		else:
			print("Saved resolution key is invalid, using default")
			option_button.selected = 0
			set_resolution(RESOLUTION_OPTIONS[0])
