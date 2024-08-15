extends Control

func _ready():
	
	#print("BestLaps _ready started")
	# Assuming the autoload singleton is named 'BestLapManager'
	var best_times_map1 = BestLapManager.get_best_times("Map1")
	#print("Best times for Map1:", best_times_map1)

	var best_times_map2 = BestLapManager.get_best_times("Map2")
	#print("Best times for Map2:", best_times_map2)

	# Update the text of each label to show the best lap times
	# Ensure the node paths match the names in your scene tree
	#print("Updating Map 1 times")
	$MarginContainer/HBoxContainer/VBoxContainer/Map.text = "Map I."
	$MarginContainer/HBoxContainer/VBoxContainer/Map11.text = "1st: %.2f" % best_times_map1[0]
	$MarginContainer/HBoxContainer/VBoxContainer/Map12.text = "2nd: %.2f" % best_times_map1[1]
	$MarginContainer/HBoxContainer/VBoxContainer/Map13.text = "3rd: %.2f" % best_times_map1[2]

	#print("Updating Map 2 times")
	$MarginContainer/HBoxContainer/VBoxContainer2/Map.text = "Map II."
	$MarginContainer/HBoxContainer/VBoxContainer2/Map21.text = "1st: %.2f" % best_times_map2[0]
	$MarginContainer/HBoxContainer/VBoxContainer2/Map22.text = "2nd: %.2f" % best_times_map2[1]
	$MarginContainer/HBoxContainer/VBoxContainer2/Map23.text = "3rd: %.2f" % best_times_map2[2]

	#print("BestLaps _ready finished")

func _on_back_pressed():
	#print("skusam stlacit")
	get_tree().change_scene_to_file("res://Scenes/MainMenu3D.tscn")
	#print("preslo to?")


func update_best_lap_display():
	# Assuming the autoload singleton is named 'BestLapManager'
	var best_times_map1 = BestLapManager.get_best_times("Map1")
	var best_times_map2 = BestLapManager.get_best_times("Map2")
	
	# Update the text of each label to show the best lap times
	$MarginContainer/HBoxContainer/VBoxContainer/Map.text = "Map I."
	$MarginContainer/HBoxContainer/VBoxContainer/Map11.text = "1st: %.2f" % best_times_map1[0]
	$MarginContainer/HBoxContainer/VBoxContainer/Map12.text = "2nd: %.2f" % best_times_map1[1]
	$MarginContainer/HBoxContainer/VBoxContainer/Map13.text = "3rd: %.2f" % best_times_map1[2]
	
	$MarginContainer/HBoxContainer/VBoxContainer2/Map.text = "Map II."
	$MarginContainer/HBoxContainer/VBoxContainer2/Map21.text = "1st: %.2f" % best_times_map2[0]
	$MarginContainer/HBoxContainer/VBoxContainer2/Map22.text = "2nd: %.2f" % best_times_map2[1]
	$MarginContainer/HBoxContainer/VBoxContainer2/Map23.text = "3rd: %.2f" % best_times_map2[2]

func _on_clear_pressed():
	BestLapManager.clear_best_times()
	# Now update the display to show the cleared times
	update_best_lap_display()
