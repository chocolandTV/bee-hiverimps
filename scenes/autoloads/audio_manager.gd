extends Node
class_name audio_manager
const MIN_PITCH :float = 0.9
const MAX_PITCH :float = 1.1
var _pitch_scale: float  = 0

enum SOUND_TYPE{
s_ui_click,
s_ui_game_over,
s_ui_game_win,
s_ambience,
s_game_music,
s_menu_music
}
############### LIST UI SOUND
@onready var ui_click_sounds :AudioStreamPlayer=$ui_click
@onready var ui_game_over_sound :AudioStreamPlayer=$ui_game_over
@onready var ui_game_win_sound :AudioStreamPlayer=$ui_game_win

##################################  LIST AMBIENCE SOUNDS
@onready var ambience_sound :AudioStreamPlayer =$game_ambience
################### LIST MUSIC
@onready var game_music_sound :AudioStreamPlayer = $game_music
@onready var menu_music_sound : AudioStreamPlayer =$game_menu

################### REFERENCE BUS
@onready var sfx_master_index = AudioServer.get_bus_index("Master")
@onready var sfx_sound_index= AudioServer.get_bus_index("SFX")
@onready var sfx_music_index= AudioServer.get_bus_index("Music")
@onready var sfx_ambience_index= AudioServer.get_bus_index("Ambience")
###################### START MANAGER #####################
func _ready():
      Emit_Sound(SOUND_TYPE.s_menu_music)
#### MANAGE MENU SOUND WHEN GAME IS PAUSED
func on_music_finished():
      Emit_Sound(SOUND_TYPE.s_game_music)

func Play_UI_Sound(sound: AudioStreamPlayer):
      if sound.playing:
            return
      _pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
      sound.pitch_scale = _pitch_scale
      sound.play()
#### Manage Player sound on position 0
func Play_Player_Sound(sound: AudioStreamPlayer):
      if sound.playing:
            return
      _pitch_scale = randf_range(MIN_PITCH, MAX_PITCH * 1.1)
      sound.pitch_scale = _pitch_scale
      sound.play()

func Play_Ambience_Sound(sound: AudioStreamPlayer):
      if sound.playing:
            return
      _pitch_scale = randf_range(MIN_PITCH, MAX_PITCH)
      sound.pitch_scale = _pitch_scale
      sound.play()
#### Manage Music loop
func Play_Music_Sound(sound : AudioStreamPlayer):
      sound.play()
#### Global Sound Function cast
func Emit_Sound(_soundType : SOUND_TYPE):
      match _soundType:
            SOUND_TYPE.s_ui_click:
                  Play_UI_Sound(ui_click_sounds)
            SOUND_TYPE.s_ui_game_over:
                  Play_UI_Sound(ui_game_over_sound)
            SOUND_TYPE.s_ui_game_win:
                  Play_UI_Sound(ui_game_win_sound)
            SOUND_TYPE.s_ambience:
                  Play_Ambience_Sound(ambience_sound)
            SOUND_TYPE.s_game_music:
                  Play_Music_Sound(game_music_sound)
            SOUND_TYPE.s_menu_music:
                  Play_Music_Sound(menu_music_sound)
            _:
                  print("ERROR SOUND TYPE")

#Sound_UI_Change integer for type 1:Master 2: Music 3: Sound 4: Ambience, float for value 0-1
func on_menu_sound_volume_change(type:int, value : float):
      match type:
            0:
                  AudioServer.set_bus_volume_db(sfx_master_index, linear_to_db(value))
                  Globals.player_settings["setting_volume_master"] = value
            1:
                  AudioServer.set_bus_volume_db(sfx_music_index, linear_to_db(value))
                  Globals.player_settings["setting_volume_music"] = value
            2:
                  AudioServer.set_bus_volume_db(sfx_sound_index, linear_to_db(value))
                  Globals.player_settings["setting_volume_sound"] = value
            3:
                  AudioServer.set_bus_volume_db(sfx_ambience_index, linear_to_db(value))
                  Globals.player_settings["setting_volume_ambience"] = value