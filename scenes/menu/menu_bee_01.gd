extends CharacterBody2D

var speed : float = 10
var lerp_speed: float = 10
var is_holding_nectar : bool = false
var is_right: bool = true

###########
var mouse_position : Vector2 = Vector2.ZERO

@onready var nectar_sprite : TextureRect =$Bee_01/TextureRect
func _input(event):
	if event.is_action_pressed("left_click"):
		mouse_position = get_global_mouse_position()
		print(mouse_position)
func _physics_process(_delta):
	handle_movement(_delta)

func handle_movement(_delta : float):
	if mouse_position != Vector2.ZERO:
		if mouse_position.distance_to(position) >3:
			velocity = mouse_position *speed
			move_and_slide()

func on_nectar_set(_value : bool):
	nectar_sprite.visible = _value
