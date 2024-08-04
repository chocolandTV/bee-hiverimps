extends Node3D

#bee speed
@export var speed: float = 10.0
# bee rotatenspeed
@export var rotation_speed: float = 1.0

# privates 
var velocity: Vector3 = Vector3()
var rotation_velocity: Vector3 = Vector3()


func _ready():
	pass


func _process(delta: float):
	handle_input(delta)
	update_movement(delta)

# Funktion zur Verarbeitung der Eingaben
func handle_input(_delta: float):
	velocity = Vector3.ZERO
	rotation_velocity = Vector3.ZERO

	# Eingaben für die Bewegung
	if Input.is_action_pressed("up"):
		velocity.z -= 1
	if Input.is_action_pressed("down"):
		velocity.z += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1

	# Eingaben für die Rotation
	if Input.is_action_pressed("rotate_left"):
		rotation_velocity.y -= 1
	if Input.is_action_pressed("rotate_right"):
		rotation_velocity.y += 1
	if Input.is_action_pressed("pitch_up"):
		rotation_velocity.x -= 1
	if Input.is_action_pressed("pitch_down"):
		rotation_velocity.x += 1
	apply_drag()

# Funktion zur Aktualisierung der Bewegung
func update_movement(_delta: float):
	# Anwenden der Bewegung
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += transform.basis *velocity * _delta

	# Anwenden der Rotation
	if rotation_velocity.length() > 0:
		var _rotation = Quaternion(Vector3(0, 1, 0), rotation_velocity.y * rotation_speed * _delta)
		_rotation *= Quaternion(Vector3(1, 0, 0), rotation_velocity.x * rotation_speed * _delta)
		rotate_object_local(Vector3(1, 0, 0), rotation_velocity.x * rotation_speed * _delta)
		rotate_object_local(Vector3(0, 1, 0), rotation_velocity.y * rotation_speed * _delta)

func apply_drag():
	velocity = velocity * 0.95
	rotation_velocity = rotation_velocity * 0.95