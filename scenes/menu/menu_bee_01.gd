extends CharacterBody2D

var speed : float = 50
var lerp_speed: float = 10
var is_holding_nectar : bool = true
var is_right: bool = true

###########
var mouse_position : Vector2 = Vector2.ZERO
var current_acceleration: float = 0.0
var acceleration : float = 10
var acceleeration_damping : float = 0.9
################### SCALE VARS BEE DIRECTION

@onready var nectar_sprite : TextureRect =$Bee_01/TextureRect
@onready var visuals : TextureRect =$Bee_01
func _input(event):
	if event.is_action_pressed("left_click"):
		mouse_position = get_global_mouse_position()

func _physics_process(_delta):
	handle_movement(_delta)

func handle_movement(_delta : float):
	if input_direction().length() !=0:
		current_acceleration  = move_toward(current_acceleration, acceleration,  acceleeration_damping * _delta)
	else:
		current_acceleration  = move_toward(current_acceleration, 0, acceleeration_damping *  _delta)
	if input_direction() != Vector2.ZERO:
		if mouse_position.distance_to(position) >3:
			var _move_direction :Vector2 =  input_direction()
			if _move_direction.x <0:
				visuals.flip_h = true
			else:
				visuals.flip_h = false

			velocity = velocity.move_toward(_move_direction* speed,current_acceleration)
			move_and_slide()
		else:
			velocity = Vector2.ZERO


func on_nectar_set(_value : bool):
	nectar_sprite.visible = _value
func input_direction() ->Vector2:
	return Vector2 (mouse_position - position)