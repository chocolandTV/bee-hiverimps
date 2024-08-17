extends Resource
class_name Fraction_Settings

enum DIFFICULT{
	EASY,
	NORMAL,
	HARD,
	INSANE
}
##### DEFINE FRACTION START SETTINGS AND DEFINES

@export_category("Fraction Defines")
@export var fraction : GAME_FRACTION.CLASS
@export var fraction_difficult : DIFFICULT
@export var fraction_isPlayer : bool
@export var unit_limit : int
@export var unit_start_water : int
@export var unit_start_nectar : int
@export var unit_start_organic : int
@export var unit_start_honey : int
@export var unit_start_population: int

####### UNIT SETUP

@export_category("Unit Settings")
@export var unit_main_prefab : PackedScene
@export var unit_damage : float
@export var unit_speed : float
@export var unit_base_wingpower :float 
@export var unit_health : float
@export var unit_health_reg : float
@export var unit_base_height : float

#### INGAME VARIABLES - CURRENT GAMES

var current_water : float = 0
var current_nectar : float  = 0
var current_organic : float = 0
var current_honey : float  = 0
var current_hives : int = 0 
var current_sectors : int =  0
var current_population : int = 0

func add_resource(_resource : GAME_RESOURCE.TYPE):
	match _resource:
		GAME_RESOURCE.TYPE.WATER:
			current_water += 1
			Ui.update_currency_values(0, current_water)
		GAME_RESOURCE.TYPE.NECTAR:
			current_nectar += 1
			Ui.update_currency_values(1, current_nectar)
		GAME_RESOURCE.TYPE.HONEY:
			current_honey += 1
			Ui.update_currency_values(2, current_honey)
		GAME_RESOURCE.TYPE.ORGANIC:
			current_organic += 1
			Ui.update_currency_values(3, current_organic)
		_:
			print("FRACTION_RESOURCE ERROR: cant add new resource, invalid resource type.")

func remove_resource(_resource : GAME_RESOURCE.TYPE, value : float):
	match _resource:
		GAME_RESOURCE.TYPE.WATER:
			current_water -= value
			Ui.update_currency_values(0, current_water)
		GAME_RESOURCE.TYPE.NECTAR:
			current_nectar -= value
			Ui.update_currency_values(1, current_nectar)
		GAME_RESOURCE.TYPE.HONEY:
			current_honey -= value
			Ui.update_currency_values(2, current_honey)
		GAME_RESOURCE.TYPE.ORGANIC:
			current_organic -= value
			Ui.update_currency_values(3, current_organic)
		_:
			print("FRACTION_RESOURCE ERROR: cant remove resource, invalid resource type.")