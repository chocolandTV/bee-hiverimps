extends Node3D
######### get from Mother
@onready var timer :Timer =$Timer
@onready var visuals_object : Node3D =$Armature

###### FOLLOW VARIABLES
var max_player_distance : float = 1000
var min_player_distance : float = 100

var faction : GAME_FACTION.CLASS
var hive : Node3D
var speed := 35.0
var fly_speed := 1.0
var max_items : int = 1
### VARIABLE IS HOLDING
var items : Array[GAME_RESOURCE.TYPE]
var current_target : Node3D
var is_moving : bool = false
var current_state : UNIT_STATE =  UNIT_STATE.IDLE
var player
var resource_list : Array[Node3D] = []

enum UNIT_STATE {
	IDLE,
	COLLECTING,
	RETURNING,
	FOLLOW
}

func _ready():
	JobGlobalManager.increase_unit_upgrade.connect(on_upgrade)
	var _units_flowers = get_tree().get_nodes_in_group("resource_point")
	player = get_tree().get_first_node_in_group("Player")

	for x in _units_flowers:
		resource_list.append(x)
	
	current_state = UNIT_STATE.IDLE

func set_stats(_faction, _hive, _speed, _flyspeed, _max_items):
	### get data on birth
	visuals_object.position = Vector3(randi_range(0,11),randi_range(0,11),randi_range(0,11)) *6.0
	faction = _faction
	hive = _hive
	speed = _speed
	fly_speed = _flyspeed
	max_items = _max_items

func on_upgrade(_faction, _value):
	if(_faction == faction):
		max_items += _value
		speed += _value
		fly_speed += _value

func _physics_process(_delta):
	handle_state()
	move(_delta)
	look_at(current_target.global_position, Vector3.UP)


func handle_state():
	if current_state != UNIT_STATE.FOLLOW and player.global_position.distance_to(global_position) > max_player_distance:
		
		current_state = UNIT_STATE.FOLLOW
		current_target = player
		return

	match current_state:
		UNIT_STATE.IDLE:
			## if cargo full
			if items.size() >= max_items:
				current_state = UNIT_STATE.RETURNING
				current_target = hive
			else:
				if unit_start_searching():
					current_state = UNIT_STATE.COLLECTING
				else:
					current_state = UNIT_STATE.FOLLOW
					current_target = player
		UNIT_STATE.COLLECTING:
			if items.size() >= max_items:
				print(" BEHAVOIUR: backpack full, going back to hive")
				current_state = UNIT_STATE.RETURNING
				current_target = hive
				### PARTICLES FINISHED COLLECTING
			elif current_target.get_parent().health_component.current_resource <= 0:
				### delete from array
				resource_list.erase(current_target)
				current_state = UNIT_STATE.IDLE
		UNIT_STATE.FOLLOW:
			if player.global_position.distance_to(global_position) < min_player_distance:
				current_state = UNIT_STATE.IDLE
		UNIT_STATE.RETURNING:
			if items.size() <= 0:
				current_state = UNIT_STATE.IDLE

func get_new_target() -> Node3D:
	var _close_targets =resource_list.filter(
		func(_resource):
			return _resource.global_position.distance_to(global_position)< max_player_distance
	)
	if _close_targets.is_empty():
		return null
	else:
		return _close_targets.pick_random()

func unit_start_searching() -> bool :
	var _temp_target = get_new_target()

	if _temp_target != null:
		current_target = _temp_target
		return true
	else:
		return false

func move(_delta):

	if current_state != UNIT_STATE.IDLE and global_position.distance_to(current_target.global_position)> 5:
		global_position = global_position.move_toward(current_target.global_position, speed *_delta)


func get_resource(_resource : GAME_RESOURCE.TYPE):
	if items.size() >= (max_items):
		return #### later drop nectar
	items.append(_resource)
	

func send_resource():
	for x in items:
		JobGlobalManager.add_resource(faction, x,1)
	items.clear()
	unit_start_searching()
	
    ### update ui

func on_timer_timeout():
	
	if current_state == UNIT_STATE.IDLE:
		unit_start_searching()

func on_enemy_entered(area : Area3D):

	timer.start()
	current_state = UNIT_STATE.IDLE
	for x in items:
		area.get_parent().get_resource(x)
	items.clear()