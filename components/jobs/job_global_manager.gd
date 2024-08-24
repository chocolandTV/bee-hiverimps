extends Node

class_name job_main_manager
@export var bee_earth : PackedScene
@export var wasp_venus : PackedScene
@export var hornet_mars : PackedScene

var faction_bee : HiveManager  =null 
var faction_wasp : HiveManager = null
var faction_hornet : HiveManager = null
var is_late_game : bool = false

signal increase_unit_upgrade(_faction : Globals,_value : int)
signal change_world()

func set_difficult():
	pass
func set_faction_manager(_faction : Globals.CLASS, _data : HiveManager):
	match _faction:
		Globals.CLASS.BEE:
			faction_bee = _data
		Globals.CLASS.WASP:
			faction_wasp = _data
		Globals.CLASS.HORNET:
			faction_hornet = _data
		_:
			print("Error, no faction selected")
func add_resource(_faction : Globals.CLASS, _resource : Globals.TYPE, _amount : int):
	match _faction:
		Globals.CLASS.BEE:
			faction_bee.add_resource(_resource, _amount)
		Globals.CLASS.WASP:
			faction_wasp.add_resource(_resource, _amount)
		Globals.CLASS.HORNET:
			faction_hornet.add_resource(_resource, _amount)
		_:
			print("Error, no faction selected")

func global_increase_unit_upgrade(_faction : Globals.CLASS,_value : int):
	increase_unit_upgrade.emit(_faction,_value)

func switch_game_to_late():
	is_late_game = true
	#### CREATE PLANETS AND HIDE HIVE
	faction_bee.start_planets(bee_earth)
	faction_wasp.start_planets(wasp_venus)
	faction_hornet.start_planets(hornet_mars)
	#CREATE WORLD 2
	change_world.emit()