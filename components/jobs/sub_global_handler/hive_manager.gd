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
@export var faction : GAME_FACTION.CLASS
@export var faction_difficult : DIFFICULT
@export var faction_isPlayer : bool
@export var unit_limit : int

####### UNIT SETUP

@export_category("Unit Settings")
@export var unit_main_prefab : PackedScene
@export var unit_damage : float  = 1
@export var unit_speed : float = 50
@export var unit_base_wingpower :float = 1
@export var unit_base_power_value : float = 1
#### INGAME VARIABLES - CURRENT GAMES

var current_water : float = 0
var current_nectar : float  = 0
var current_organic : float = 0
var current_honey : float  = 0
var current_hivepower : int = 0

func _ready():
	JobGlobalManager.set_faction_manager(faction, self)
func add_resource(_resource : GAME_RESOURCE.TYPE):
	match _resource:
		GAME_RESOURCE.TYPE.WATER:
			current_water += faction_difficult
			Ui.update_resource_values(_resource, current_water)
		GAME_RESOURCE.TYPE.NECTAR:
			current_nectar += faction_difficult
			Ui.update_resource_values(_resource, current_nectar)
		GAME_RESOURCE.TYPE.HONEY:
			current_honey += faction_difficult
			Ui.update_resource_values(_resource, current_honey)
		GAME_RESOURCE.TYPE.ORGANIC:
			current_organic += faction_difficult
			Ui.update_resource_values(_resource, current_organic)
		_:
			print("FACTION_RESOURCE ERROR: cant add new resource, invalid resource type.")

func remove_resource(_resource : GAME_RESOURCE.TYPE, value : float):
	match _resource:
		GAME_RESOURCE.TYPE.WATER:
			current_water -= value
			Ui.update_resource_values(_resource, current_water)
		GAME_RESOURCE.TYPE.NECTAR:
			current_nectar -= value
			Ui.update_resource_values(_resource, current_nectar)
		GAME_RESOURCE.TYPE.HONEY:
			current_honey -= value
			Ui.update_resource_values(_resource, current_honey)
		GAME_RESOURCE.TYPE.ORGANIC:
			current_organic -= value
			Ui.update_resource_values(_resource, current_organic)
		_:
			print("FACTION_RESOURCE ERROR: cant remove resource, invalid resource type.")