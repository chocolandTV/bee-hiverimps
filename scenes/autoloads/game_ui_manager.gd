extends Control
class_name game_ui_manager

var UI : ui_class
var MENU : menu_class
################### PRELOAD #####################
const game_scene = "res://scenes/_game/game.tscn"
var spawn_game_scene

enum GAME_STATE {
	MENU,
	PAUSED,
	RUNNING
}
var current_state : GAME_STATE = GAME_STATE.MENU
signal button_shooted()
#signal game_started()
signal game_paused()
signal game_resume()

func _ready():
	UI = get_child(0)
	MENU = get_child(1)

	ResourceLoader.load_threaded_request(game_scene)
	spawn_game_scene = ResourceLoader.load_threaded_get(game_scene)

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


func on_button_shooted():
	button_shooted.emit()

func on_game_started():
	print("GAME_UI_MANAGER: GAME STARTED")
	# game_started.emit()
	# change_game_state(GAME_STATE.RUNNING)
	# get_tree().change_scene_to_packed.call_deferred(spawn_game_scene)

func on_game_paused():
	game_paused.emit()
	change_game_state(GAME_STATE.PAUSED)
func on_game_resumed():
	game_resume.emit()
	change_game_state(GAME_STATE.RUNNING)