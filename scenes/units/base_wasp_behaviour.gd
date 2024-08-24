extends Node3D
######### get from Mother

@onready var visuals_object : Node3D =$Armature
@export var particle : CPUParticles3D
var faction : GAME_FACTION.CLASS
var hive : Node3D
var speed := 35.0
var fly_speed := 1.0
var max_items : int = 5

### VARIABLE IS HOLDING
var items : Array[GAME_RESOURCE.TYPE]
var current_target : Node3D
var is_moving : bool = false
var current_state : UNIT_STATE =  UNIT_STATE.IDLE
var resource_list : Array[Node3D] = []

enum UNIT_STATE {
	IDLE,
	COLLECTING,
	RETURNING
}

func _ready():
	JobGlobalManager.increase_unit_upgrade.connect(on_upgrade)
	var _units_flowers = get_tree().get_nodes_in_group("resource_point")
	
	for x in _units_flowers:
		resource_list.append(x)
	
	current_state = UNIT_STATE.IDLE
	JobGlobalManager.change_world.connect(on_world_change)

func on_world_change():
	current_state = UNIT_STATE.IDLE

func set_stats(_faction, _hive, _speed, _flyspeed, _max_items):
	### get data on birth
	visuals_object.position = Vector3(randi_range(0,15),randi_range(0,15),randi_range(0,15))
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

	match current_state:
		UNIT_STATE.IDLE:
			## if cargo full
			if items.size() >= max_items:
				current_state = UNIT_STATE.RETURNING
				current_target = hive
			else:
				var _temp = ResourceListComponent.get_random_resource()
				if _temp != null:
					current_target = _temp
					current_state = UNIT_STATE.COLLECTING
				else: 
					current_target  = null
					current_state = UNIT_STATE.IDLE
		UNIT_STATE.COLLECTING:
			if items.size() >= max_items:
				particle.emitting = true
				current_state = UNIT_STATE.RETURNING
				current_target = hive
				### PARTICLES FINISHED COLLECTING
			elif current_target.get_parent().health_component.current_resource <= 0:
				### delete from array
				resource_list.erase(current_target)
				current_state = UNIT_STATE.IDLE
		UNIT_STATE.RETURNING:
			if items.size() <= 0:
				particle.emitting = false
				current_state = UNIT_STATE.IDLE
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