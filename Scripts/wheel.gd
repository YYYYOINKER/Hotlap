extends RayCast3D

@onready var car: RigidBody3D = get_parent().get_parent()
const GRAVITY = 9.81
var previous_spring_length: float = 0.0

@export var is_front_wheel: bool

func _ready():
	add_exception(car)
	self.enabled = true

func _physics_process(delta):

	if is_colliding():
		var collision_point = get_collision_point()
	
		suspension(delta, collision_point)
		acceleration(collision_point)
		
		apply_z_force(collision_point)
		apply_x_force(delta, collision_point)
		
		position_wheel(collision_point, delta)
		

func apply_x_force(delta, collision_point):
	var dir: Vector3 = global_basis.x
	var tire_world_vel: Vector3 = get_point_velocity(global_position)
	var lateral_vel: float = dir.dot(tire_world_vel)
	
	var grip = car.rear_tire_grip
	#print(grip)
	if grip < 1.4:
		$"../../Smoke".emitting = true 
		$"../../Smoke2".emitting = true
	else:
		$"../../Smoke".emitting = false
		$"../../Smoke2".emitting = false
		
	if is_front_wheel:
		grip = car.front_tire_grip
		
	var desired_vel_change: float = -lateral_vel * grip
	var x_force = 0.7* desired_vel_change + delta
	
	car.apply_force(dir * x_force, collision_point - car.global_position)
	
	if car.debug:
		DebugDraw3D.draw_arrow_line(global_position, global_position + (dir * x_force), Color.RED, 0.1, true)

func get_point_velocity(point: Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)


func apply_z_force(collision_point):
	var dir: Vector3 = global_basis.z
	var tire_world_vel: Vector3 = get_point_velocity(global_position)
	var z_force = dir.dot(tire_world_vel) * car.mass / 10
	
	car.apply_force(-dir * z_force, collision_point - car.global_position)
	
	var point = Vector3(collision_point.x, collision_point.y + car.wheel_radius, collision_point.z)
	
	if car.debug:
		DebugDraw3D.draw_arrow_line(point, point + (-dir * z_force * 2), Color.BLUE_VIOLET, 0.1, true)


func acceleration(collision_point):
	if is_front_wheel or car.in_neutral:
		return
	
	# Get the current speed limit for the current gear
	var speed_limit = car.get_current_speed_limit()

	# Get current speed of the car in m/s
	var current_speed_m_per_s = car.linear_velocity.length()

	# Check if the current speed exceeds the speed limit
	if abs(current_speed_m_per_s) > abs(speed_limit):
		# Current speed exceeds speed limit, prevent further acceleration
		return

	var accel_dir = -global_basis.z
	if car.in_reverse:
		print("car in reverse from wheel script")
		accel_dir = global_basis.z  # Reverse the direction for reverse gear

	var engine_torque = car.get_engine_torque(car.current_rpm)
	var torque_multiplier = car.gear_ratios[abs(car.current_gear)]
	var torque = car.accel_input * engine_torque * torque_multiplier

	var point = Vector3(collision_point.x, collision_point.y + car.wheel_radius, collision_point.z)

	car.apply_force(accel_dir * torque, point - car.global_position)

	if car.debug:
		DebugDraw3D.draw_arrow_line(point, point + (accel_dir * torque), Color.BLUE, 0.1, true)


func suspension(delta, collision_point):
	# the direction the force will be applied
	var susp_dir = global_basis.y

	var raycast_origin = global_position
	var raycast_dest = collision_point
	var distance = raycast_dest.distance_to(raycast_origin)

	var spring_length = clamp(distance - car.wheel_radius, 0, car.suspension_rest_dist)

	var spring_force = car.spring_strength * (car.suspension_rest_dist - spring_length)

	var spring_velocity = (previous_spring_length - spring_length) / delta

	var damper_force = car.spring_damper * spring_velocity

	var suspension_force = basis.y * (spring_force + damper_force)

	previous_spring_length = spring_length

	var point = Vector3(collision_point.x, collision_point.y + car.wheel_radius, collision_point.z)
	car.apply_force(susp_dir * suspension_force, point - car.global_position)
	
	if car.debug:
		#DebugDraw3D.draw_sphere(point, 0.1)
		DebugDraw3D.draw_arrow_line(global_position, to_global(position + Vector3(-position.x, (suspension_force.y / 2), -position.z)), Color.GREEN, 0.1, true)
		DebugDraw3D.draw_line_hit_offset(global_position, to_global(position + Vector3(-position.x, -1, -position.z)), true, distance, 0.2, Color.RED, Color.RED)

const WHEEL_ROTATION_FACTOR = 360.0  # Degrees in a circle
func position_wheel(collision_point: Vector3, delta: float):
	var wheel_instance = get_child(0)
	
	# Calculate the desired position for the wheel_instance
	var wheel_position = collision_point + Vector3(0, car.wheel_radius, 0)
	
	# Set the wheel_instance's global position to the desired position
	wheel_instance.global_transform.origin = wheel_position

	# Determine the rotation direction based on the car's forward movement
	var forward_direction = car.global_transform.basis.z.normalized()
	var velocity_direction = car.linear_velocity.normalized()
	var move_direction
	if forward_direction.dot(velocity_direction) >= 0:
		move_direction = 1  # Moving forward
	else:
		move_direction = -1  # Moving backward

	# Calculate the rotation speed of the wheel based on the linear velocity and wheel radius
	var wheel_circumference = 2.0 * PI * car.wheel_radius
	var wheel_rotation_speed = (car.linear_velocity.length() / wheel_circumference) * WHEEL_ROTATION_FACTOR * move_direction

	# Apply the rotation to the wheel
	wheel_instance.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(wheel_rotation_speed) * delta)

	# If the wheel is supposed to turn (steering), set the rotation along the Y-axis
	if is_front_wheel:
		var steering_rotation = car.steering_input * car.steering_angle
		wheel_instance.rotation.y = steering_rotation

