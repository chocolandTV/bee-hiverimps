extends CharacterBody2D
class_name bee_unit
# @export var unit_settings : UnitSettings
enum Bee_State{
	IDLE = 0,
	COLLECTING = 1,
	FIGHT = 2,
	EXPANDING = 3,
	DEFENDING = 4
}
enum Bee_Ressource{
	WATER = 0,
	NECTAR = 1,
	ORGANIC = 2,
	HONEY = 3
}

@export var selected = false
@onready var box = $Selection_box
@onready var anim :AnimationPlayer = $AnimationPlayer
@onready var target = position
@onready var nectar_comp  = $nectar_component
@onready var timer : Timer =$resource_timer

var follow_cursor  = false
var unit_speed = 50
var body_radius = 30

## transporting resource
var is_transporting_resource : bool = false

## current  action state
var current_bee_state : Bee_State
## current collection state
var current_collect_state : Bee_Ressource

#### current hive
var current_hive : StaticBody2D
### current collecting_resource
var current_resource_point : StaticBody2D
#### Debug
func _ready():
	current_bee_state = Bee_State.IDLE
	body_radius = $CollisionShape2D.shape.radius
	current_hive = get_tree().get_first_node_in_group("Hive")
	set_selected(selected)

func _input(event):
	if event.is_action_pressed("right_click") and selected:
		target = get_global_mouse_position()
		anim.play("walk")

func _physics_process(_delta):
	if selected:
		follow_target()
	else:
		handle_jobs()

func set_selected(value):
	selected = value
	box.visible = value
	#effect ?

func set_job( _job : Bee_State):
	if current_collect_state == Bee_State.COLLECTING:
		if is_transporting_resource && _job != Bee_State.COLLECTING: 
			## if worker should collect other resource, drop object
			# instance resource
			print("drop resource")
			is_transporting_resource = false

	current_bee_state = _job

func start_collecting(_ressource : Bee_Ressource, res_point : StaticBody2D):
	set_job(Bee_State.COLLECTING)
	current_resource_point  = res_point
	current_collect_state = _ressource
	timer.start()

func abort_collecting():
	timer.stop()

func follow_target():

	velocity = position.direction_to(target) * unit_speed
	if position.distance_to(target) > 25:
	## check if enemy is nearby
		move_and_slide()
	else: 
		anim.stop()
		## check if job is nearby
		## change current_bee_state


func _on_resource_timer_timeout():
	match current_collect_state:
		Bee_Ressource.NECTAR:
			if !is_transporting_resource:
				print ("get nectar")
				is_transporting_resource = true
				nectar_comp.get_nectar()
				## create nectar object - attach and bee move to base with nectar
		_:
			#default
			print("error default case on- n_on_resource_timer_timeout()")
	anim.play("walk")
	target = current_hive.position
	print("back to hive")

func handle_jobs():
	
	velocity = position.direction_to(target) * unit_speed
	if position.distance_to(target) > 25:
	## check if enemy is nearby
		move_and_slide()
	else:
		anim.stop()
		
	## JOB 1 AUTO COLLECTING
	## JOB 2 AUTO FIGHTING
	## JOB 3 AUTO DEFENDING (route)
	## JOB 5 AUTO EXPANDING