extends Node3D
#enum
enum BeeState
{
	FLYING = 0,
	LANDING = 1,
	GROUNDED = 2,
	TAKEOFF= 3,
	CRASHING= 4
}
# variables
@export_category("BeeSettings")
@export var body_drag_factors :Vector3= Vector3(0.1, 1.0, 0.001)

@export var drag_coefficient : float = 0.001
@export var lift_coefficient : float = 0.1

@export var body_mass : float = 1.0
@export var max_pitch_rate_dps :float = 90.0
@export var max_roll_rate_dps : float = 180.0
@export var max_thrust_n : float =10.0
@export var max_brake_n : float  = 3.0

@export var max_yaw_rate_dps :float = 30.0
@export var rotate_into_wind_lerp_factor :float = 0.7

#audiosource variable
#flap_start_time animation

#privates
var local_velocity : Vector3
var current_state : BeeState
var move_direction : Vector2
var look_direction : Vector2
var flap_start_time : float
#handle input
func _input(_event):
	move_direction = Input.get_vector("right","left","down","up")

func _physics_process(delta):
	handle_flying(delta)

#handle flying
func handle_flying(_delta : float):
	if current_state == BeeState.GROUNDED:
		handle_grounded()
	if current_state == BeeState.TAKEOFF:
		flying(_delta)

func handle_grounded():
	pass
func flying(_delta : float):
	var time_since_flap_start = Time.get_ticks_msec() - flap_start_time

	# apply thrust during the downwards flap 
	var thrust_input :float = move_direction.y

	var thrust_input_when_flapping : float =thrust_input * clamp(time_since_flap_start, 0.1,0.01)
	var thrust_force : float = (thrust_input_when_flapping) * max_thrust_n
	var brake_force : float = move_direction.y *max_brake_n
	var roll_delta :float = -move_direction.x * max_roll_rate_dps *_delta
	var pitch_delta :float = look_direction.x * max_pitch_rate_dps * _delta
	var yaw_delta  :float = look_direction.y * max_yaw_rate_dps * _delta

	var prev_transform : Transform3D = transform
	var prev_local_velocity : Vector3 = local_velocity
	var prev_local_velocity_abs : Vector3 = Vector3(
		absf(prev_local_velocity.x * prev_local_velocity.x),
		absf(prev_local_velocity.y * prev_local_velocity.y),
		absf(prev_local_velocity.z * prev_local_velocity.z)
	)
	#rotate into wind
	var prev_world_velocity = prev_transform.translated(prev_local_velocity)
	# var world_rotation_into_wind = look_rotation(prev_local_velocity, prev_transform.up)

#func create a quaternion, that show forward in a specific direction
func look_rotation(forward: Vector3, up: Vector3 = Vector3(0, 1, 0)) -> Quaternion:
	forward = forward.normalized()
	var right = up.cross(forward).normalized()
	up = forward.cross(right)

	var m = Basis()
	m.set_axis(0, right)
	m.set_axis(1, up)
	m.set_axis(2, forward)

	return Quaternion(m)