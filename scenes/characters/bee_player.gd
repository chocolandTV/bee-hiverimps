extends CharacterBody3D

@export var speed := 10.0
@export var boost_speed := 20.0
@export var rotation_speed := 5.0

# For smoother controller/mouse movement
@export var acceleration := 5.0
@export var fraction : GAME_FRACTION.CLASS
var player_velocity := Vector3.ZERO
var is_boosting := false

# Mouse sensitivity for look around
@export var mouse_sensitivity := Vector2(0.1, 0.1)
var mouse_position : Vector2
# Camera and orientation
@export var camera: Camera3D
var rotation_x := 0.0
var rotation_y := 0.0

func _ready():
    if camera == null:
        camera = get_node("Camera3D")
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
    _handle_input(delta)
    _move(delta)
    _rotate(delta)

func _input(event):
    if event is InputEventMouseMotion:
        mouse_position = event.position

# Handle both keyboard/mouse and controller input
func _handle_input(delta):
    var input_direction := Vector3.ZERO

    # Keyboard input
    if Input.is_action_pressed("move_forward"):
        input_direction.z -= 1
    if Input.is_action_pressed("move_backward"):
        input_direction.z += 1
    if Input.is_action_pressed("move_left"):
        input_direction.x -= 1
    if Input.is_action_pressed("move_right"):
        input_direction.x += 1
    if Input.is_action_pressed("move_up"):
        input_direction.y += 1
    if Input.is_action_pressed("move_down"):
        input_direction.y -= 1
    
    # Controller input (assuming the left stick for movement, right stick for look)
    var controller_direction := Vector3(
        Input.get_axis("left_stick_left", "left_stick_right"),
        Input.get_axis("left_trigger", "right_trigger"),  # Assuming triggers for up/down
        Input.get_axis("left_stick_up", "left_stick_down")
    )
    
    # Combine inputs
    if controller_direction != Vector3.ZERO:
        input_direction = controller_direction

    # Normalize to prevent faster diagonal movement
    if input_direction.length() > 1:
        input_direction = input_direction.normalized()

    # # Boost handling (for both controller and keyboard)
    # is_boosting = Input.is_action_pressed("fly_boost")

    # Update player_velocity smoothly
    var target_speed := boost_speed #if is_boosting else speed
    var target_velocity := input_direction * target_speed
    player_velocity = player_velocity.lerp(target_velocity, acceleration * delta)

# Move the bee based on player_velocity
func _move(_delta):
    move_and_slide()

# Rotate the bee based on mouse or controller input
func _rotate(delta):
    # Mouse look
    var mouse_delta := mouse_position * mouse_sensitivity
    rotation_x -= mouse_delta.y
    rotation_y -= mouse_delta.x

    # Clamp vertical rotation
    rotation_x = clamp(rotation_x, -90.0, 90.0)

    # Rotate the bee
    rotation.y = rotation_y
    camera.rotation.x = deg_to_rad(rotation_x)

    # Controller look
    var controller_look : Vector2 = Vector2(
        Input.get_axis("right_stick_left", "right_stick_right"),
        Input.get_axis("right_stick_up", "right_stick_down")
    ) * rotation_speed * delta

    rotation_y -= controller_look.x
    rotation_x -= controller_look.y
    rotation_x = clamp(rotation_x, -90.0, 90.0)

    # Apply the rotations
    rotation.y = rotation_y
    camera.rotation.x = deg_to_rad(rotation_x)
