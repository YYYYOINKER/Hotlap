extends Node

var best_times_file = "user://best_times.cfg"
var config = ConfigFile.new()

func _ready():
	load_best_times()

func load_best_times():
	var error = config.load(best_times_file)
	if error == ERR_FILE_NOT_FOUND:
		initialize_default_best_times()

func initialize_default_best_times():
	# Initialize with default best times for each map
	config.set_value("Map1", "times", [9999.0, 9999.0, 9999.0])
	config.set_value("Map2", "times", [9999.0, 9999.0, 9999.0])
	# ... add additional maps as needed
	config.save(best_times_file)

func save_best_time(map_name: String, time: float) -> void:
	var error = config.load(best_times_file)
	if error != OK and error != ERR_FILE_NOT_FOUND:
		print("Failed to load best times file: ", best_times_file)
		return

	var times = config.get_value(map_name, "times", [])
	times.append(time)
	times.sort()
	times = times.slice(0, 3)
	
	config.set_value(map_name, "times", times)
	config.save(best_times_file)

func get_best_times(map_name: String) -> Array:
	var error = config.load(best_times_file)
	if error != OK:
		print("Could not load best times, returning default values.")
		return [9999.0, 9999.0, 9999.0]
	return config.get_value(map_name, "times", [9999.0, 9999.0, 9999.0])

func clear_best_times() -> void:
	var maps = ["Map1", "Map2"]  
	for map_name in maps:
		config.set_value(map_name, "times", [9999.0, 9999.0, 9999.0])
	config.save(best_times_file)
