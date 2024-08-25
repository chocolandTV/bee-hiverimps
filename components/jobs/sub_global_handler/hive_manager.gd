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
@export var current_faction : Globals.CLASS
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
	if current_water > (unit_cost + current_unit_count):
		print("New_Unit:  cost: %s Faction %s : unitcount: %s" %[ "Water", current_faction, current_unit_count])
		return true
	if current_nectar > (unit_cost + current_unit_count) :
		print("New_Unit:  %s Faction %s : unitcount: %s" %[ "Nectar", current_faction, current_unit_count])
		return true
	if current_organic > (unit_cost + current_unit_count) :
		print("New_Unit:  %s Faction %s : unitcount: %s" %[ "Organic", current_faction, current_unit_count])
		return true
	if current_honey > (unit_cost + current_unit_count):
		print("New_Unit:  %s Faction %s : unitcount: %s" %[ "Honey", current_faction, current_unit_count])
		return true
	return false

func buy_unit():
	if current_water > (unit_cost + current_unit_count):
		current_water -= (unit_cost + current_unit_count)
		if faction_isPlayer:
			GameUiManager.UI.update_resource_values(Globals.RESOURCES.WATER, current_water)

	if current_nectar > (unit_cost + current_unit_count):
		current_nectar -= (unit_cost + current_unit_count)
		if faction_isPlayer:
			GameUiManager.UI.update_resource_values(Globals.RESOURCES.NECTAR, current_nectar)

	if current_organic > (unit_cost + current_unit_count):
		current_organic -= (unit_cost + current_unit_count)
		if faction_isPlayer:
			GameUiManager.UI.update_resource_values(Globals.RESOURCES.ORGANIC, current_organic)

	if current_honey > (unit_cost + current_unit_count) :
		current_honey -= (unit_cost + current_unit_count)
		if faction_isPlayer:
			GameUiManager.UI.update_resource_values(Globals.RESOURCES.HONEY, current_honey)
	spawn_unit()

	current_factionpower += unit_base_power_value
	faction_sector_object.scale += Vector3(unit_base_power_value,unit_base_power_value,unit_base_power_value) *facton_sector_objects_size
	##### UPGRADE CAPACITY
	current_unit_count += 1

	if faction_isPlayer:
		GameUiManager.UI.update_quest(current_unit_count)
		if current_unit_count >= 100:
			GameUiManager.UI.set_win_panel(true)

	if current_unit_count >= upgrade_steps:
		upgrade_steps += 10
		current_unit_max_capacity += 2
		### filter faction
		if current_faction == Globals.CLASS.BEE:
			GameUiManager.UI.set_player_info_box("Bees upgraded,Speed:%d,Capacity:%d" % [unit_speed + current_unit_max_capacity, current_unit_max_capacity])
		if current_faction == Globals.CLASS.WASP:
			GameUiManager.UI.set_player_info_box("Wasps upgraded,Speed:%d,Capacity:%d" % [unit_speed + current_unit_max_capacity, current_unit_max_capacity])
		if current_faction == Globals.CLASS.HORNET:
			GameUiManager.UI.set_player_info_box("Hornets upgraded,Speed:%d,Capacity:%d" % [unit_speed + current_unit_max_capacity, current_unit_max_capacity])
		print("FACTION UPGRADE %d : LEVEL %d" % [float(upgrade_steps)/10, current_unit_max_capacity])
		JobGlobalManager.global_increase_unit_upgrade(current_faction, current_unit_max_capacity)

	GameUiManager.UI.update_faction_power(current_faction,current_factionpower)
	GameUiManager.UI.update_progressbar_factionpower(current_faction, current_factionpower)
	
func add_resource(_resource : Globals.RESOURCES, _amount :int):
	match _resource:
		Globals.RESOURCES.WATER:
			current_water += _amount
			if faction_isPlayer:
				GameUiManager.UI.update_resource_values(_resource, current_water)
				GameUiManager.UI.update_progressbar_resource(_resource, current_water)
		Globals.RESOURCES.NECTAR:
			current_nectar += _amount
			if faction_isPlayer:
				GameUiManager.UI.update_resource_values(_resource, current_nectar)
				GameUiManager.UI.update_progressbar_resource(_resource, current_nectar)
		Globals.RESOURCES.HONEY:
			current_honey += _amount
			if faction_isPlayer:
				GameUiManager.UI.update_resource_values(_resource, current_honey)
				GameUiManager.UI.update_progressbar_resource(_resource, current_honey)
		Globals.RESOURCES.ORGANIC:
			current_organic += _amount
			if faction_isPlayer:
				GameUiManager.UI.update_resource_values(_resource, current_organic)
				GameUiManager.UI.update_progressbar_resource(_resource, current_organic)
		_:
			print("FACTION_RESOURCE ERROR: cant add new resource, invalid resource type.")

func remove_resource(_resource : Globals.RESOURCES, value : float):
	match _resource:
		Globals.RESOURCES.WATER:
			current_water -= value
			if faction_isPlayer:
				GameUiManager.update_resource_values(_resource, current_water)
		Globals.RESOURCES.NECTAR:
			current_nectar -= value
			if faction_isPlayer:
				GameUiManager.UI.update_resource_values(_resource, current_nectar)
		Globals.RESOURCES.HONEY:
			current_honey -= value
			if faction_isPlayer:
				GameUiManager.UI.update_resource_values(_resource, current_honey)
		Globals.RESOURCES.ORGANIC:
			current_organic -= value
			if faction_isPlayer:
				GameUiManager.UI.update_resource_values(_resource, current_organic)
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

