extends Control
class_name menu_class
var id: int =0

var current_state : Globals.MENU_STATE = Globals.MENU_STATE.MAIN

func set_menu_state(new_state : Globals.MENU_STATE):
	match new_state:
		Globals.MENU_STATE.START_GAME:
			print("CAST MENU START GAME")
			GameUiManager.on_game_started()
		Globals.MENU_STATE.RESUME:
			pass
		Globals.MENU_STATE.MAIN:
			pass
		Globals.MENU_STATE.SETTINGS:
			pass
		Globals.MENU_STATE.CREDITS:
			pass
			
		_:
			print("ERROR MENU SWITCH STATE")
