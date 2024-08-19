extends Node3D
######### get from Mother
@onready var timer :Timer =$Timer

var faction : GAME_FACTION.CLASS
var hive : Node3D
var speed := 35.0
var fly_speed := 1.0
var max_items : int = 1
### VARIABLE IS HOLDING
var items : Array[GAME_RESOURCE.TYPE]
var target_position : Vector3
var is_moving : bool = false
var current_state : UNIT_STATE =  UNIT_STATE.IDLE

var resource_list : Array[Node3D] = []

enum UNIT_STATE {
	IDLE,
	COLLECTING,
	RETURNING
}

func _ready():
	JobGlobalManager.increase_unit_capacity.connect(on_upgrade)
	var _units_flowers = get_tree().get_nodes_in_group("resource_point")
	var _player = get_tree().get_first_node_in_group("Player")
	for x in _units_flowers:
		resource_list.append(x)
	if _player != null:

		resource_list.append(_player)
		resource_list.append(_player)
		resource_list.append(_player)
		resource_list.append(_player)
		resource_list.append(_player)
		resource_list.append(_player)
		resource_list.append(_player)
		resource_list.append(_player)
		resource_list.append(_player)
	unit_start_searching()


func on_upgrade(_faction, _value):
	if(_faction == faction):
		max_items = _value

func _process(_delta):
	handle_state()
	move(_delta)
	look_at(target_position, Vector3.UP)


func handle_state():
	if current_state == UNIT_STATE.COLLECTING:
		if items.size() >= max_items:
			current_state = UNIT_STATE.RETURNING
			target_position = hive.global_position
			### PARTICLES FINISHED COLLECTING


	if current_state == UNIT_STATE.RETURNING:
		if items.size() <= 0:
			unit_start_searching()
		# check if target reached then send resources

func get_new_target() -> Vector3:
	return resource_list.pick_random().global.position

func unit_start_searching():
	print("BEEHAVIOUR: Start searching")
	target_position = get_new_target()
	print("got new target", target_position)
	current_state = UNIT_STATE.COLLECTING

func move(_delta : float):
	if current_state != UNIT_STATE.IDLE:
		var move_direction =  (global_position - target_position).normalized()
		global_position += move_direction * _delta * speed
	

func get_resource(_resource : GAME_RESOURCE.TYPE):
	if items.size() >= (max_items):
		return #### later drop nectar
	items.append(_resource)
	print("BEEHAVIOUR: got resource")

func send_resource():
	for x in items:
		JobGlobalManager.add_resource(faction, x,1)
	items.clear()
	unit_start_searching()
	print("BEEHAVIOUR: give Hive all my resources")
    ### update ui

func on_timer_timeout():
	print("BEEHAVIOUR: Restart after Damage")
	if current_state == UNIT_STATE.IDLE:
		unit_start_searching()

func on_enemy_entered(area : Area3D):

	timer.start()
	current_state = UNIT_STATE.IDLE
	for x in items:
		area.get_parent().get_resource(x)
	items.clear()
	print("BEEHAVIOUR: Get Damage : Idle and enemy %d:" % area.get_parent().name)