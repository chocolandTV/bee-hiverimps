extends Node
signal sound_value_changed(type : int, value : float)
signal player_mouse_changed(value :float)
signal player_use_controller(value : bool)

enum CLASS {
	BEE,
	WASP,
	HORNET
}
enum RESOURCES {
	WATER,
	NECTAR,
	ORGANIC,
	HONEY
}
var player_settings = {
      "setting_volume_master" : 0.5,
      "setting_volume_sound" : 0.5,
      "setting_volume_music" : 0.5,
      "player_mouse_sensitivity" : 0.5,
      "player_name" : "Player_Default",
      "controller_enabled" : true,
      "Y_Axis_Inverted" : true,
      "game_version" : "1.0"
}
func on_sound_value_changed(_type : int, _value):
      sound_value_changed.emit(_type,_value)
func on_player_mouse_changed(_value : float):
      player_mouse_changed.emit(_value)
func on_player_use_controller(_value : bool):
      player_use_controller.emit(_value)
