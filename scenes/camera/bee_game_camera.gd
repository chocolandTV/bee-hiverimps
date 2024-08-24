extends Camera3D

@export var player : CharacterBody3D  = null
@export var target_distance : float = 4.2
@export var target_height : float = 1.4

# CAMERA LERP SPEED
var camera_lerp_speed : float = 20.0
var camera_look_speed : float = 5.0
# FOLLOW TARGET 
var follow_target  =null

# LAST LOOKAT POSITION
var last_lookat


func _ready():
	follow_target = player
	last_lookat = follow_target.global_transform.origin

func _physics_process(_delta):
	handle_rotation(_delta)
	handle_position(_delta)

func handle_rotation(_delta):
	### get player rotation, move_towards in step
	rotation.x = rotation.x.move_toward(follow_target.global_rotation.x,_delta * camera_look_speed)
	rotation.y = rotation.y.move_toward(follow_target.global_rotation.y,_delta * camera_look_speed)
	rotation.z = rotation.z.move_toward(follow_target.global_rotation.z,_delta * camera_look_speed)

func handle_position(_delta):
	###get player position, move_towards in steps
	global_position.move_toward(
