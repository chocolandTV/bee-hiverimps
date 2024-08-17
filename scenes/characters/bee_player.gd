extends CharacterBody3D

@export var speed := 35.0
@export var rotation_speed := 35.0
@export var fly_speed := 1.0

# For smoother controller/mouse movement
@export var acceleration := 3.5
@export var fraction : GAME_FRACTION.CLASS
# Mouse sensitivity for look around
@export var mouse_sensitivity := Vector2(0.1, 0.1)
#CONST
const STRAFE_DAMPING : float = 0.75
#move_towards
var current_acceleration :float = 0.0

var camera : Camera3D
var body_velocity : Vector3
var is_boosting : bool =false
######### mouse data
var last_mouse_relative : Vector2
## get difference from mouse motion
var mouse_relative : Vector2
var fly_relative : float
#### Directions 
var move_direction : Vector2
var look_direction : Vector2 
var fly_direction : float = 0.0

func _ready():
    # get Camera
    pass

func _input(event):
    move_direction = Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
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
        #get vector for difference
        look_direction = last_mouse_relative - mouse_relative
        print("look_direction: ", look_direction)
        #set last mouseposition
        last_mouse_relative = mouse_relative

func _physics_process(_delta):
    current_acceleration  = move_toward(current_acceleration, acceleration, _delta)

    body_velocity = Vector3(move_direction.x * 0.75,fly_relative, move_direction.y)
    velocity = lerp(velocity, body_velocity * speed, acceleration* _delta) #   3.5 * 0.001
    #body_velocity= move_toward(0, acceleration, _delta)
    move_and_slide()