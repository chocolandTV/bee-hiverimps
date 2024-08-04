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

#handle input
func _input(_event):
	move_direction = Input.get_vector("right","left","down","up")

func _physics_process(delta):
	handle_flying(delta)

#handle flying
func handle_flying(_delta : float):
	pass

