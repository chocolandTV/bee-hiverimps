extends Node

class_name job_main_manager

var faction_bee : HiveManager  =null 
var faction_wasp : HiveManager = null
var faction_hornet : HiveManager = null


func set_faction_manager( _faction : GAME_FACTION.CLASS, _data : HiveManager):
	match _faction:
		GAME_FACTION.CLASS.BEE:
			faction_bee = _data
		GAME_FACTION.CLASS.WASP:
			faction_wasp = _data
		GAME_FACTION.CLASS.HORNET:
			faction_hornet = _data
		_:
			print("Error, no faction selected")
func add_resource( _faction : GAME_FACTION.CLASS, _resource : GAME_RESOURCE.TYPE):
	match _faction:
		GAME_FACTION.CLASS.BEE:
			faction_bee.add_resource(_resource)
		GAME_FACTION.CLASS.WASP:
			faction_wasp.add_resource(_resource)
		GAME_FACTION.CLASS.HORNET:
			faction_hornet.add_resource(_resource)
		_:
			print("Error, no faction selected")