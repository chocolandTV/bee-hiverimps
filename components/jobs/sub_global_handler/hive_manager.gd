extends Node3D
class_name HiveManager

enum DIFFICULT{
	EASY =0,
	NORMAL = 1,
	HARD = 2,
	INSANE= 5
}
##### DEFINE FACTION START SETTINGS AND DEFINES

@export_category("Faction Defines")
@export var current_faction : GAME_FACTION.CLASS
@export var faction_difficult : DIFFICULT
@export var faction_isPlayer : bool
@export var unit_limit : int
@export var faction_sector_object : MeshInstance3D
@export var facton_sector_objects_size: float
@export var faction_hive : Node3D
####### UNIT SETUP

@export_category("Unit Settings")
@export var unit_main_prefab : PackedScene
@export var unit_cost : int = 1
@export var unit_speed : float = 35
@export var unit_base_wingpower :float = 1
@export var unit_base_power_value : int = 1
#### INGAME VARIABLES - CURRENT GAMES

var current_water : float = 0
@export  var current_nectar : float  = 0
var current_organic : float = 0
var current_honey : float  = 0
var current_factionpower : int = 0
########  current unit count
var current_unit_count : int = 0
var current_unit_max_capacity : int = 5
var upgrade_steps : int = 10
var is_buyable :bool = false
func _ready():
	JobGlobalManager.set_faction_manager(current_faction, self)
func _process(_delta):
	is_buyable = check_resource()
	if is_buyable:
		buy_unit()
		is_buyable = false

func check_resource() -> bool:
	if current_water > unit_cost * 20:
		print(" can buy with water")
		return true
	if current_nectar > unit_cost *10 :
		print(" can buy with nectar")
		return true
	if current_organic > unit_cost *10 :
		print(" can buy with organic")
		return true
	if current_honey > unit_cost * 5:
		print(" can buy with honey")
		return true
	return false

func buy_unit():
	if current_water > unit_cost * 10:
		current_water -= unit_cost * 10
		if faction_isPlayer:
			Ui.update_resource_values(GAME_RESOURCE.TYPE.WATER, current_water)

	if current_nectar > unit_cost *5 :
		current_nectar -= unit_cost * 5
		if faction_isPlayer:
			Ui.update_resource_values(GAME_RESOURCE.TYPE.NECTAR, current_nectar)

	if current_organic > unit_cost *2 :
		current_organic -= unit_cost *2
		if faction_isPlayer:
			Ui.update_resource_values(GAME_RESOURCE.TYPE.ORGANIC, current_organic)

	if current_honey > unit_cost :
		current_honey -= unit_cost
		if faction_isPlayer:
			Ui.update_resource_values(GAME_RESOURCE.TYPE.HONEY, current_honey)
	spawn_unit()

	current_factionpower += unit_base_power_value
	faction_sector_object.scale += Vector3(unit_base_power_value,unit_base_power_value,unit_base_power_value) *facton_sector_objects_size
	##### UPGRADE CAPACITY
	current_unit_count += 1

	if faction_isPlayer:
		Ui.update_quest(current_unit_count)
		if current_unit_count >= 100:
			Ui.set_win_panel(true)

	if current_unit_count >= upgrade_steps:
		upgrade_steps += 10
		current_unit_max_capacity += 2
		print("FACTION UPGRADE %d : LEVEL %d" % [upgrade_steps, current_unit_max_capacity])
		JobGlobalManager.global_increase_unit_upgrade(current_faction, current_unit_max_capacity)

	Ui.update_faction_power(current_faction,current_factionpower)
	
func add_resource(_resource : GAME_RESOURCE.TYPE, _amount :int):
	match _resource:
		GAME_RESOURCE.TYPE.WATER:
			current_water += _amount
			if faction_isPlayer:
				Ui.update_resource_values(_resource, current_water)
		GAME_RESOURCE.TYPE.NECTAR:
			current_nectar += _amount
			if faction_isPlayer:
				Ui.update_resource_values(_resource, current_nectar)
		GAME_RESOURCE.TYPE.HONEY:
			current_honey += _amount
			if faction_isPlayer:
				Ui.update_resource_values(_resource, current_honey)
		GAME_RESOURCE.TYPE.ORGANIC:
			current_organic += _amount
			if faction_isPlayer:
				Ui.update_resource_values(_resource, current_organic)
		_:
			print("FACTION_RESOURCE ERROR: cant add new resource, invalid resource type.")

func remove_resource(_resource : GAME_RESOURCE.TYPE, value : float):
	match _resource:
		GAME_RESOURCE.TYPE.WATER:
			current_water -= value
			if faction_isPlayer:
				Ui.update_resource_values(_resource, current_water)
		GAME_RESOURCE.TYPE.NECTAR:
			current_nectar -= value
			if faction_isPlayer:
				Ui.update_resource_values(_resource, current_nectar)
		GAME_RESOURCE.TYPE.HONEY:
			current_honey -= value
			if faction_isPlayer:
				Ui.update_resource_values(_resource, current_honey)
		GAME_RESOURCE.TYPE.ORGANIC:
			current_organic -= value
			if faction_isPlayer:
				Ui.update_resource_values(_resource, current_organic)
		_:
			print("FACTION_RESOURCE ERROR: cant remove resource, invalid resource type.")

func start_planets(_instance : PackedScene):
	var instance = _instance.instantiate()
	get_child(0).add_child(instance)
	instance.global_position = get_child(0).global_position
	get_child(0).get_child(0).visible = false
func spawn_unit():
	#### prefab
	var instance = unit_main_prefab.instantiate()
	add_child(instance)
	instance.global_position = global_position
	###give stats
	instance.set_stats(current_faction, faction_hive, unit_speed + current_unit_max_capacity, unit_base_wingpower + current_unit_max_capacity, current_unit_max_capacity)

