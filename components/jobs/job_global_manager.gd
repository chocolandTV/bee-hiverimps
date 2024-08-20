extends Node

class_name job_main_manager

var faction_bee : HiveManager  =null 
var faction_wasp : HiveManager = null
var faction_hornet : HiveManager = null


signal increase_unit_upgrade(_faction : GAME_FACTION,_value : int)

func set_difficult():
	pass
func set_faction_manager(_faction : GAME_FACTION.CLASS, _data : HiveManager):
	match _faction:
		GAME_FACTION.CLASS.BEE:
			faction_bee = _data
		GAME_FACTION.CLASS.WASP:
			faction_wasp = _data
		GAME_FACTION.CLASS.HORNET:
			faction_hornet = _data
		_:
			print("Error, no faction selected")
func add_resource(_faction : GAME_FACTION.CLASS, _resource : GAME_RESOURCE.TYPE, _amount : int):
	match _faction:
		GAME_FACTION.CLASS.BEE:
			faction_bee.add_resource(_resource, _amount)
		GAME_FACTION.CLASS.WASP:
			faction_wasp.add_resource(_resource, _amount)
		GAME_FACTION.CLASS.HORNET:
			faction_hornet.add_resource(_resource, _amount)
		_:
			print("Error, no faction selected")

func global_increase_unit_upgrade(_faction : GAME_FACTION.CLASS,_value : int):
	increase_unit_upgrade.emit(_faction,_value)