extends Control

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu3D.tscn")

#auticka

func _on_porsche_pressed():
	#GameData.selected_car = 
	#print("Porshce ", GameData.selected_map)
	#LoadingScreen.load_scene("res://Scenes/world.tscn")
	if GameData.selected_map == "res://Scenes/world.tscn":
		LoadingScreen.load_scene("res://Scenes/world.tscn")
	elif GameData.selected_map == "res://Scenes/world_2.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_2_ff_base_porsche.tscn")
	else :
		LoadingScreen.load_scene("res://Scenes/world_3.tscn")

func _on_nsx_pressed():
	if GameData.selected_map == "res://Scenes/world.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_1f_nsx.tscn")
	elif GameData.selected_map == "res://Scenes/world_2.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_2_ff_base_nsx.tscn")
	else :
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_3_ff_nsx.tscn")

func _on_mercedes_pressed():
	if GameData.selected_map == "res://Scenes/world.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_1f_merc.tscn")
	elif GameData.selected_map == "res://Scenes/world_2.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_2_ff_base_mercedes.tscn")
	else :
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_3_ff_mercedes.tscn")


func _on_supra_pressed():
	if GameData.selected_map == "res://Scenes/world.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_1f_supra.tscn")
	elif GameData.selected_map == "res://Scenes/world_2.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_2_ff_base_supra.tscn")
	else :
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_3_ff_supra.tscn")


func _on_rx_7_pressed():
	if GameData.selected_map == "res://Scenes/world.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_1f_rx7.tscn")
	elif GameData.selected_map == "res://Scenes/world_2.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_2_ff_base_rx7.tscn")
	else :
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_3_ff_rx7.tscn")


func _on_formula_pressed():
	if GameData.selected_map == "res://Scenes/world.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_1f_f1.tscn")
	elif GameData.selected_map == "res://Scenes/world_2.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_2_ff_base_f1.tscn")
	else :
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_3_ff_f1.tscn")


func _on_evo_pressed():
	if GameData.selected_map == "res://Scenes/world.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_1f_evo.tscn")
	elif GameData.selected_map == "res://Scenes/world_2.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_2_ff_base_evo.tscn")
	else :
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_3_ff_evo.tscn")


func _on_challenger_pressed():
	if GameData.selected_map == "res://Scenes/world.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_1f_dodge.tscn")
	elif GameData.selected_map == "res://Scenes/world_2.tscn":
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_2_ff_base_dodge.tscn")
	else :
		LoadingScreen.load_scene("res://Scenes/CarMapCombos/world_3_dodge.tscn")
