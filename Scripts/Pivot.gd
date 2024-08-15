extends Node3D

@export var rotation_speed = 0.005
@export var max_vertical_angle = deg_to_rad(20)
@export var min_vertical_angle = deg_to_rad(-50)
var neutral_horizontal_angle = 0.0
var neutral_vertical_angle = 0.0
@export var return_speed = 1.0
@export var steering_rotation_speed = 0.05
@export var max_steering_angle = deg_to_rad(15)
var steering: bool = false
var rotating = false
var current_vertical_angle = 0.0
var cumulative_steering_rotation = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			rotating = event.is_pressed()
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN if rotating else Input.MOUSE_MODE_VISIBLE)

	if rotating and event is InputEventMouseMotion:
		# Manual rotation
		var horizontal_rotation = -event.relative.x * rotation_speed
		rotate_y(horizontal_rotation)

		# Vertical rotation
		var vertical_rotation_change = -event.relative.y * rotation_speed
		current_vertical_angle += vertical_rotation_change
		current_vertical_angle = clamp(current_vertical_angle, min_vertical_angle, max_vertical_angle)
		$".".rotation.x = current_vertical_angle

func _process(delta):
	if not rotating:
		# Keyboard input for steering
		var steering_input = Input.get_axis("turn_right", "turn_left")
		var steering_rotation = steering_input * steering_rotation_speed

		# Check if steering input is not 0
		steering = abs(steering_input) > 0.0

		# Debugging: Print the steering input
		#print("Steering Input: ", steering_input)

		# Reset cumulative steering rotation to 0 when steering input is 0
		if abs(steering_input) < 0.01:
			cumulative_steering_rotation = 0.0

		# Update cumulative steering rotation within the specified range
		cumulative_steering_rotation += steering_rotation
		cumulative_steering_rotation = clamp(cumulative_steering_rotation, -max_steering_angle, max_steering_angle)

		# Adjust horizontal rotation based on cumulative steering rotation
		var target_horizontal_angle = neutral_horizontal_angle + cumulative_steering_rotation

		# Use lerp to smoothly interpolate to the target horizontal angle
		rotation.y = lerp(rotation.y, target_horizontal_angle, return_speed * delta)

		# Lerp the vertical angle
		current_vertical_angle = lerp(current_vertical_angle, neutral_vertical_angle, return_speed * delta)
		$".".rotation.x = current_vertical_angle
