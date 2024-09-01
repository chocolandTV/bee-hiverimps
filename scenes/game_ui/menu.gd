extends Control
class_name menu_class
var current_state : Globals.MENU_STATE = Globals.MENU_STATE.MAIN
var is_resume :bool = false
@onready var start_label : Label = $Button_PanelContainer/MarginContainer/VBoxContainer/Start_Panel/Start_Texture/Label_start

func set_menu_state(new_state : Globals.MENU_STATE):
	AudioManager.Emit_Sound(AudioManager.SOUND_TYPE.s_ui_click)
	match new_state:
		Globals.MENU_STATE.START_GAME:
			if !is_resume:
				GameUiManager.on_game_started()
				set_resume()
			else: 
				set_menu_state(Globals.MENU_STATE.RESUME)

		Globals.MENU_STATE.RESUME:
			GameUiManager.on_game_resumed()
		Globals.MENU_STATE.MAIN:
			pass
		Globals.MENU_STATE.SETTINGS:
			pass
		Globals.MENU_STATE.CREDITS:
			pass
			
		_:
			print("ERROR MENU SWITCH STATE")

func set_resume():
	start_label.text ="Resume"

