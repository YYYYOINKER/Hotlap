extends RigidBody3D

@onready var gear_label: Label = $CarInfo/MarginContainer/VBoxContainer/Gear
@onready var speed_label: Label = $CarInfo/MarginContainer/VBoxContainer/Speed
@onready var needle: Sprite2D = $CarInfo/MarginContainer/Sprite2D2
@onready var engine_sound: AudioStreamPlayer = $EngineSound


@export var car_type: String = "Default"
@export var suspension_rest_dist: float = 0.6
@export var spring_strength: float = 12
@export var spring_damper: float = 1
@export var wheel_radius: float = 0.22

@export var debug: bool = false
@export var engine_power: float = 6

var accel_input

@export var steering_angle: float = 25
@export var front_tire_grip: float = 4
@export var rear_tire_grip: float = 1.8

var air_density: float = 1.225  # kg/m^3 
@export var frontal_area: float = 2.2  # m^2 
@export var rolling_resistance_factor: float = 0.015  


var current_rpm: float = 0
var current_gear: int = 1
var max_rpm: float = 7000
var gear_ratios: Array = [0, -0.8, 1, 1.1, 1.3, 1.5, 1.5] 
var max_speeds_per_gear: Array = [0, -10, 48, 72, 103, 132, 158] 

var shift_up_rpm: float = 2000 
var shift_down_rpm: float = 0 
var steering_input

var in_neutral: bool = true  
var in_reverse: bool = false 


# Top speed / gear
var car_max_speeds = {
	"Porsche": [0, -20, 45, 75, 110, 145, 185],  # Porsche 911
	"Dodge": [0, -20, 40, 65, 95, 125, 165],     # Dodge Challenger
	"Supra": [0, -20, 50, 80, 115, 150, 180],     # Toyota Supra MK4
	"RX7": [0, -20, 48, 78, 110, 140, 170],       # Mazda RX7 Spirit R
	"Mercedes": [0, -20, 47, 75, 105, 135, 165],  # Mercedes 190Evo2
	"EVO": [0, -20, 45, 70, 100, 130, 160],       # Mitsubishi Lancer Evo 7
	"NSX": [0, -20, 46, 73, 105, 140, 175],       # Old Honda NSX
	"F1": [0, -30, 100, 150, 200, 250, 300]       # Formula 1 Car
	# ... dalsie auta
}

func _ready():
	# Set the engine sound for the car type
	var sound_path = "res://SFX/" + car_type + ".wav"
	engine_sound.stream = load(sound_path)
	engine_sound.play()
	
	# Set the max speeds based on the car type
	if car_max_speeds.has(car_type):
		max_speeds_per_gear = car_max_speeds[car_type]
	else:
		print("Unknown car type: ", car_type)
	engine_sound.stream = preload("res://SFX/porsche.wav") 
	engine_sound.play()

func _physics_process(delta):
	handle_input()
	
	#accel_input = Input.get_axis("reverse", "accelerate")
	accel_input = 	Input.get_action_strength("ui_up")
	#print("accel input: ",accel_input)
	#steering_input = Input.get_axis("turn_right", "turn_left")
	steering_input = Input.get_axis("ui_right", "ui_left")
	var steering_rotation = steering_input * steering_angle
	
	
		
	if in_reverse and accel_input > 0:
		accel_input = -1*accel_input
	elif current_gear > 0 and accel_input < 0:
		# When in any forward gear and the acceleration input is negative (e.g., the player is trying to reverse), ignore this input.
		accel_input = 0
	


	
	var fl_wheel = $Wheels/FL_Wheel
	var fr_wheel = $Wheels/FR_Wheel
	#update_rpm(delta)
	if steering_rotation != 0:
		# Apply steering rotation
		var angle = clamp(fl_wheel.rotation.y + steering_rotation, -steering_angle, steering_angle)
		var new_rotation = angle * delta
		
		fl_wheel.rotation.y = lerp(fl_wheel.rotation.y, new_rotation, 0.3)
		fr_wheel.rotation.y = lerp(fr_wheel.rotation.y, new_rotation, 0.3)

		adjust_rear_grip_dynamically(steering_input, accel_input)

	else:
		fl_wheel.rotation.y = move_toward(fl_wheel.rotation.y, 0.0, 0.2)
		fr_wheel.rotation.y = move_toward(fr_wheel.rotation.y, 0.0, 0.2)
		restore_rear_grip(delta)
		
	var speed_kmh = linear_velocity.length() * 3.6

	# Prevent acceleration if the maximum speed for the current gear is reached
	if speed_kmh >= max_speeds_per_gear[current_gear]:
		accel_input = min(accel_input, 0)  # Allow deceleration or maintaining speed, but not acceleration
	update_rpm(delta)
	update_needle()
	update_engine_sound()
	speed_label.text = "Speed: %d km/h" % int(speed_kmh)
	# Convert gear to a string that makes sense (e.g., R for reverse, N for neutral)
	var gear_text = "N" if in_neutral else ("R" if in_reverse else str(current_gear -1 ))
	gear_label.text = "Gear: %s" % gear_text
		
func update_needle():
	# Normalize the RPM value to a 0-1 range where 0 is 1000 RPM and 1 is 7000 RPM
	var rpm_normalized = (current_rpm - 1000) / (7000 - 1000)
	# Calculate the needle's angle within the range (from 33 degrees to 230 degrees)
	var needle_angle = lerp(33, 230, rpm_normalized)
	needle.rotation_degrees = needle_angle
	
func update_rpm(delta):
	var wheel_circumference = 2 * PI * wheel_radius
	# Calculate speed_kmh inside this function
	var speed_kmh = linear_velocity.length() * 3.6
	var vehicle_speed = linear_velocity.dot(transform.basis.z.normalized()) # project velocity onto forward direction
	var wheel_rpm = (vehicle_speed / wheel_circumference) * 60 # convert m/s to RPM

	# Use gear ratio to calculate engine RPM based on wheel RPM, accounting for neutral and reverse
	var gear_ratio = gear_ratios[current_gear] if current_gear > 0 else 1
	var engine_rpm = wheel_rpm * gear_ratio

	# If the vehicle is in neutral and the engine RPM is below idle, set it to idle RPM
	if in_neutral and engine_rpm < idle_rpm:
		engine_rpm = idle_rpm

	# Interpolate towards the target RPM based on the current gear and speed
	var target_rpm = engine_rpm
	if current_gear > 0 and current_gear < max_speeds_per_gear.size():
		var max_speed_for_gear = max_speeds_per_gear[current_gear]
		target_rpm = map_range_clamped(speed_kmh, 0, max_speed_for_gear, idle_rpm, max_rpm)

	current_rpm = lerp(current_rpm, target_rpm, rpm_increase_factor * delta)
	current_rpm = clamp(current_rpm, idle_rpm, max_rpm)

	#print("engine rpm",current_rpm, "ratio",gear_ratios, "wheel rpm",wheel_rpm)
func update_engine_sound():
	var rpm_normalized = (current_rpm - idle_rpm) / (max_rpm - idle_rpm)
	engine_sound.pitch_scale = remap(rpm_normalized, 0.0, 1.0, 0.75, 1.5)  # Example range, adjust as needed


func get_torque_at_rpm(rpm):
	var max_torque = 280 
	var peak_rpm = 5700
	var torque = max_torque * rpm / peak_rpm
	return clamp(torque, 0, max_torque)
	

func get_current_speed_limit() -> float:
	if in_reverse:
		return -max_speeds_per_gear[1]
	else:
		return max_speeds_per_gear[abs(current_gear)]

func get_engine_torque(rpm):
	return engine_power 

var idle_rpm: float = 1000  # Idle RPM
var rpm_increase_factor: float = 100  

func calculate_rpm(delta):
	if not in_neutral:
		current_rpm += accel_input * rpm_increase_factor * delta / gear_ratios[current_gear]
	else:
		# Idle RPM when in neutral
		current_rpm = idle_rpm
	# Clamp RPM between idle RPM and max RPM
	current_rpm = clamp(current_rpm, idle_rpm, max_rpm)


func adjust_rear_grip_dynamically(steering_input, accel_input):
	var oversteer_factor = max(abs(steering_input), abs(accel_input))
	
	var grip_reduction = 1.0 - (oversteer_factor * 0.1)
	
	# Smoothly interpolate the rear tire grip towards the reduced grip
	rear_tire_grip = lerp(rear_tire_grip, grip_reduction, 0.1)
	
func restore_rear_grip(delta):
	# Restore rear tire grip when not steering, at a dynamic rate based on current grip
	var restore_rate = 0.05 + max(0.0, (2.0 - rear_tire_grip) * 2)  # Accelerate restoration as grip gets closer to normal
	
	# Smoothly interpolate the rear tire grip back to normal
	rear_tire_grip = lerp(rear_tire_grip, 2.0, restore_rate * delta)
	
func shift_up():
	print("Current gear before shifting up:", current_gear)
	if in_reverse:
		print("Shifting from Reverse to Neutral")
		in_reverse = false
		in_neutral = true
		current_gear = 0
	elif in_neutral:
		print("Shifting from Neutral to 1st Gear")
		in_neutral = false
		current_gear = 2  # First gear is at index 2
	elif current_gear < gear_ratios.size() - 1:
		print("Shifting up one gear")
		current_gear += 1
	update_gear_label()

func shift_down():
	print("Current gear before shifting down:", current_gear)
	if current_gear == 2 and linear_velocity.length() * 3.6 < 5:
		print("Shifting from 1st gear to Neutral")
		in_neutral = true
		current_gear = 0
	elif current_gear > 2:
		print("Shifting down one gear")
		current_gear -= 1
	elif in_neutral:
		print("Shifting from Neutral to Reverse")
		in_neutral = false
		in_reverse = true
		current_gear = 1  # Reverse gear is at index 1
	update_gear_label()

func update_gear_label():
	if in_neutral:
		gear_label.text = "Gear: N"
	elif in_reverse:
		gear_label.text = "Gear: R"
	else:
		gear_label.text = "Gear: " + str(current_gear - 1)  # Gear display for 1st gear onward

func handle_input():
	if Input.is_action_just_pressed("shift_up"):
		shift_up()
	elif Input.is_action_just_pressed("shift_down"):
		shift_down()


func map_range_clamped(value, from_min, from_max, to_min, to_max):
	var from_range = from_max - from_min
	var to_range = to_max - to_min
	var scaled_value = (value - from_min) / from_range if from_range else 0
	return clamp(scaled_value * to_range + to_min, to_min, to_max)
