extends Node

class_name job_main_manager

@export var fraction_bee : Fraction_Settings
@export var fraction_wasp : Fraction_Settings
@export var fraction_hornet : Fraction_Settings

#JobGlobalManager.add_nectar(x.fraction)
func add_resource( _fraction : GAME_FRACTION.CLASS, _resource : GAME_RESOURCE.TYPE):
	match _fraction:
		GAME_FRACTION.CLASS.BEE:
			fraction_bee.add_resource(GAME_RESOURCE.TYPE.NECTAR)
		GAME_FRACTION.CLASS.WASP:
			fraction_wasp.add_resource(GAME_RESOURCE.TYPE.NECTAR)
		GAME_FRACTION.CLASS.HORNET:
			fraction_hornet.add_resource(GAME_RESOURCE.TYPE.NECTAR)
		_:
			print("Error, no fraction selected")