extends Control
class_name game_ui_manager

var UI : ui_class
var MENU : menu_class

enum GAME_STATE {
	MENU,
	PAUSED,
	RUNNING
}
var current_state : GAME_STATE = GAME_STATE.MENU
func _ready():
	UI = get_child(0)
	MENU = get_child(1)
	print(UI)
	print(MENU)
func change_game_state(value : GAME_STATE):
	match value:
		GAME_STATE.MENU:
			current_state = GAME_STATE.MENU
			MENU.visible =true
			UI.visible = false
		GAME_STATE.PAUSED:
			current_state = GAME_STATE.PAUSED
			get_tree().paused = true
			MENU.visible =true
			UI.visible = false
		GAME_STATE.RUNNING:
			current_state = GAME_STATE.RUNNING
			get_tree().paused = false
			MENU.visible =false
			UI.visible = true
		_:
			print("errror Gamestate")