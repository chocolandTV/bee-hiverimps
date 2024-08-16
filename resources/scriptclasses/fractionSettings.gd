extends Node
class_name Fraction_Settings

enum FRACTION {
	BEE,
	WASP,
	HORNET
}
enum DIFFICULT{
	EASY,
	NORMAL,
	HARD,
	INSANE
}
##### DEFINE FRACTION START SETTINGS AND DEFINES
@export_category("Fraction Defines")
@export var fraction : FRACTION
@export var fraction_difficult : DIFFICULT
@export var fraction_startpoint : Node3D
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
