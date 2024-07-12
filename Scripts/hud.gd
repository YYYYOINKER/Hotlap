extends Control

# References to the HUD elements
@onready var steering_wheel = $Wheel
@onready var gas_pedal = $Gas
@onready var brake_pedal = $Brakes

# Update function
func _process(_delta):
	# Steering Input
	var steering_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	steering_wheel.rotation_degrees = steering_input * 160  
	
	gas_pedal.value = Input.get_action_strength("ui_up")
	brake_pedal.value = Input.get_action_strength("ui_down")
