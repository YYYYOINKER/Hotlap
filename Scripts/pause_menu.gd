extends CanvasLayer

var paused = false # This variable will keep track of the pause state.

func _ready():
	# Set the node to process even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide() # Initially hide the pause menu

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		get_tree().paused = paused
		if paused:
			show() # Show the pause menu
		else:
			hide() # Hide the pause menu

func _on_continue_pressed():
	# Resume the game
	paused = false
	get_tree().paused = false
	hide() # Hide the pause menu

func _on_quit_pressed():
	# Change to the main menu scene
	get_tree().paused = false # Unpause before changing the scene
	get_tree().change_scene_to_file("res://Scenes/prva_s_hudbou.tscn")
	
