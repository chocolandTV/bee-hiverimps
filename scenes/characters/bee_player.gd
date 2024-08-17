extends CharacterBody3D

@export var speed := 35.0
@export var rotation_speed := 35.0
@export var rotation_damping := 0.5
@export var fly_speed := 1.0

# For smoother controller/mouse movement
@export var acceleration := 3.5
@export var acceleeration_damping := 0.5
@export var fraction : GAME_FRACTION.CLASS
# Mouse sensitivity for look around
@export var mouse_sensitivity := 0.6
@export var camera : Camera3D
@export var clamp_angle : Vector2 = Vector2(-45, 45)
@onready var bee_mesh : Node3D = $mainBee
#CONST
const STRAFE_DAMPING : float = 0.75
#move_towards
var current_acceleration :float = 0.0

var move_direction : Vector3

######### mouse data
var last_mouse_relative : Vector2
## get difference from mouse motion
var mouse_relative : Vector2
var fly_relative : float

####### rotate_towards
var current_rotation_x : float = 0
var current_rotation_y : float = 0

#### Directions 
var input_direction : Vector2
var look_direction : Vector2 
var fly_direction : float = 0.0

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
    input_direction = Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
    if event.is_action_pressed("move_up"):
        fly_relative = 1
    if event.is_action_released("move_up"):
        fly_relative = 0

    if event.is_action_pressed("move_down"):
        fly_relative = -1
    if event.is_action_released("move_down"):
        fly_relative = 0

    if event is InputEventMouseMotion:
        #get new mouseposition
        mouse_relative = event.relative

func _process(_delta):
    rotate_y(-mouse_relative.x * (mouse_sensitivity / 1000))

func _physics_process(_delta):
    if input_direction.length() !=0 or fly_relative != 0:
        current_acceleration  = move_toward(current_acceleration, acceleration,  acceleeration_damping * _delta)
    else:
        current_acceleration  = move_toward(current_acceleration, 0, acceleeration_damping *  _delta)

    move_direction = Vector3(input_direction.x * STRAFE_DAMPING,fly_relative, input_direction.y)
    velocity = velocity.move_toward(move_direction* speed, current_acceleration)
    move_and_slide()