extends CharacterBody2D

# @export var unit_settings : UnitSettings

@export var selected = false
@onready var box = $Selection_box
@onready var anim :AnimationPlayer = $AnimationPlayer
@onready var target = position
@onready var nectar_comp : Nectar_Component = $nectar_component

var follow_cursor  = false
var unit_speed = 50
var body_radius = 30

# gets_nectar variable calls in FLOWER_RESOURCE_01.gd on body entered and turn off on body exited
var receiving_nectar : bool = false
## transporting resource
var is_transporting_resource : bool = false
#### Debug

func _input(event):
	if event.is_action_pressed("right_click"):
		follow_cursor = true
		
	if event.is_action_released("right_click"):
		follow_cursor = false

func _ready():
	body_radius = $CollisionShape2D.shape.radius
	set_selected(selected)

func _physics_process(_delta):
	follow_target()

func set_selected(value):
	selected = value
	box.visible = value
	#effect ?

func follow_target():
	if follow_cursor:
		if selected:
			target = get_global_mouse_position()

			anim.play("walk")
	velocity = position.direction_to(target) * unit_speed
	if position.distance_to(target) > 25:
		move_and_slide()
	else: 
		anim.stop()

func _on_resource_timer_timeout():
	if receiving_nectar and !is_transporting_resource:
		is_transporting_resource = true
		nectar_comp.get_nectar()
		## create nectar object - attach and bee move to base with nectar
		
