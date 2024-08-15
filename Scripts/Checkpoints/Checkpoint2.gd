extends Node3D
# Global (file-level) sector times
var sector_1_time = 0.0
var sector_2_time = 0.0
var sector_3_time = 0.0
var best_lap_time = 9999.0

# Timer start times
var sector_1_start_time = 0
var sector_2_start_time = 0
var sector_3_start_time = 0

# Label references
@onready var lap_time_last_label = $LapTimes/MarginContainer/VBoxContainer/Last
@onready var lap_time_label = $LapTimes/MarginContainer/VBoxContainer/Lap
@onready var sector_1_time_label = $LapTimes/MarginContainer/VBoxContainer/Sector1
@onready var sector_2_time_label = $LapTimes/MarginContainer/VBoxContainer/Sector2
@onready var sector_3_time_label = $LapTimes/MarginContainer/VBoxContainer/Sector3

# Race state flags
var race_started = false
var first_pass_finish = true

func _ready() -> void:
	pass  # No initialization required for Time.get_ticks_msec()

func _on_checkpoint_sector_1_body_entered(body: PhysicsBody3D) -> void:
	if body.name == "Car" and race_started:
		sector_1_time = (Time.get_ticks_msec() - sector_1_start_time) / 1000.0
		sector_1_time_label.text = "Sector 1 Time: %.2f" % sector_1_time
		sector_2_start_time = Time.get_ticks_msec()  # Start Sector 2 timer

func _on_checkpoint_sector_2_body_entered(body: PhysicsBody3D) -> void:
	if body.name == "Car" and race_started:
		sector_2_time = (Time.get_ticks_msec() - sector_2_start_time) / 1000.0
		sector_2_time_label.text = "Sector 2 Time: %.2f" % sector_2_time
		sector_3_start_time = Time.get_ticks_msec()  # Start Sector 3 timer

func _on_checkpoint_sector_3_body_entered(body: PhysicsBody3D) -> void:
	if body.name == "Car":
		if not first_pass_finish:
			sector_3_time = (Time.get_ticks_msec() - sector_3_start_time) / 1000.0
			sector_3_time_label.text = "Sector 3 Time: %.2f" % sector_3_time
			calculate_and_display_lap_time()
			sector_1_start_time = Time.get_ticks_msec()  # Start Sector 1 timer for new lap
		else:
			first_pass_finish = false
			race_started = true
			sector_1_start_time = Time.get_ticks_msec()  # Start Sector 1 timer

func calculate_and_display_lap_time():
	# Calculate the total lap time
	var lap_time = sector_1_time + sector_2_time + sector_3_time
	
	# Always save the lap time using BestLapManager
	BestLapManager.save_best_time("Map2", lap_time)

	# Update the lap time label regardless of whether it was the best lap or not
	lap_time_label.text = "Lap Completed: %.2f" % lap_time

	# Optionally, update the best lap label if this was the best lap
	if lap_time < best_lap_time:
		best_lap_time = lap_time
		lap_time_last_label.text = "Best Lap: %.2f" % best_lap_time

	# Clear the sector times for the next lap
	sector_1_time = 0.0
	sector_2_time = 0.0
	sector_3_time = 0.0

	# Clear the sector time labels for the new lap
	sector_1_time_label.text = "Sector 1 Time: --"
	sector_2_time_label.text = "Sector 2 Time: --"
	sector_3_time_label.text = "Sector 3 Time: --"
