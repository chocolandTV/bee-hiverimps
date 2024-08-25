extends Control
class_name ui_class
@onready var altitude_meter : PanelContainer =$Altitute_Label
@onready var altitude_label : Label = $Altitute_Label/MarginContainer/Label
############# PROGRESS BARS 
@onready var progress_water: ProgressBar =$PanelContainer/MarginContainer/GridContainer/Progress_Water
@onready var progress_nectar: ProgressBar =$PanelContainer/MarginContainer/GridContainer/Progress_Nectar
@onready var progress_organic: ProgressBar =$PanelContainer/MarginContainer/GridContainer/Progress_Organics
@onready var progress_honey: ProgressBar =$PanelContainer/MarginContainer/GridContainer/Progress_Honey


@onready var progress_beepower: ProgressBar =$PanelContainer/MarginContainer/GridContainer/Progress_Bee
@onready var progress_wasppower: ProgressBar =$PanelContainer/MarginContainer/GridContainer/Progress_Wasp
@onready var progress_hornetpower: ProgressBar =$PanelContainer/MarginContainer/GridContainer/Progress_Hornet

############ VALUE TEXT
@onready var label_resource_water_value : Label = $PanelContainer/MarginContainer/GridContainer/water_value
@onready var label_resource_nectar_value : Label = $PanelContainer/MarginContainer/GridContainer/nectar_value
@onready var label_resource_organic_value : Label = $PanelContainer/MarginContainer/GridContainer/organic_value
@onready var label_resource_honey_value : Label = $PanelContainer/MarginContainer/GridContainer/honey_value
############## VALUE FACTION POWER TEXT
@onready var label_faction_beepower_value : Label = $PanelContainer/MarginContainer/GridContainer/beepower_value
@onready var label_faction_wasppower_value : Label = $PanelContainer/MarginContainer/GridContainer/wasppower_value
@onready var label_faction_hornetpower_value : Label = $PanelContainer/MarginContainer/GridContainer/hornetpower_value
########  VALUE CAPACITY RESOURCE
@onready var label_capacity_water : Label =$Inventar_Panel/MarginContainer/GridContainer/water_label
@onready var label_capacity_nectar : Label =$Inventar_Panel/MarginContainer/GridContainer/nectar_label
@onready var label_capacity_organic : Label =$Inventar_Panel/MarginContainer/GridContainer/organic_label
@onready var label_capacity_honey : Label =$Inventar_Panel/MarginContainer/GridContainer/honey_label
############# value quest label
@onready var quest_label : Label =$New_Unit_Panel/MarginContainer/Panel/MarginContainer/VBoxContainer/Quest_Label
############# value win screen
@onready var win_container : PanelContainer =$Win_Container
#################  player speed vbox script
@onready var play_vbox_container : VBoxContainer  = $Speed_Debug/MarginContainer/VBoxContainer
var player_node : CharacterBody3D
var window_size : Vector2  =Vector2 (1920,1080)
var game_allready_won : bool =false
var _lategame = false
var game_ui: game_ui_manager
func _ready():
	player_node = get_tree().get_nodes_in_group("Player")[0]
	# DisplayServer.window_get_size()
	# windows_size  =  get_viewport().get_visible_rect().size
	window_size = get_viewport().get_window().size * 0.94
	game_ui = get_parent()

func update_player_node_speed_ui(value: CharacterBody3D):
	play_vbox_container.set_player(value)

func clear_player_backpack():
	label_capacity_water.text = str(0)
	label_capacity_nectar.text = str(0)
	label_capacity_organic.text= str(0)
	label_capacity_honey.text = str(0)

func update_quest(_value):
	quest_label.text= ("%s /100" % str(_value))

func set_win_panel(_value : bool):
	if _value and !game_allready_won:
		game_allready_won = true
		win_container.on_win_menu(_value)

func update_player_backpack(_resource : Globals.TYPE, _value : int):
	match _resource:
		Globals.TYPE.WATER:
			label_capacity_water.text = str(_value)
		Globals.TYPE.NECTAR:
			label_capacity_nectar.text = str(_value)
		Globals.TYPE.ORGANIC:
			label_capacity_organic.text= str(_value)
		Globals.TYPE.HONEY:
			label_capacity_honey.text = str(_value)
		_:
			#default
			print("Error update Resource_value, no matches on _Type were found : ", _resource)

func update_resource_values(_type : Globals.TYPE,_value : float):
	match _type:
		Globals.TYPE.WATER:
			label_resource_water_value.text = str(_value)
		Globals.TYPE.NECTAR:
			label_resource_nectar_value.text = str(_value)
		Globals.TYPE.ORGANIC:
			label_resource_organic_value.text= str(_value)
		Globals.TYPE.HONEY:
			label_resource_honey_value.text = str(_value)
		_:
			#default
			print("Error update Resource_value, no matches on _Type were found : ", _type)

func update_faction_power(_faction : Globals.CLASS, _value : int):
	match _faction:
		Globals.CLASS.BEE:
			label_faction_beepower_value.text = str(_value)
		Globals.CLASS.WASP:
			label_faction_wasppower_value.text = str(_value)
		Globals.CLASS.HORNET:
			label_resource_organic_value.text= str(_value)
		_:
			#default
			print("Error update FactionPower _value, no matches on _Type were found : ", _faction)
################################################################################################################


#######  PROGRESS BAR UPDATER

################################################################################################################
func update_progressbar_resource(_type : Globals.TYPE,_value : float):
	match _type:
		Globals.TYPE.WATER:
			progress_water.set_value_no_signal(_value)
		Globals.TYPE.NECTAR:
			progress_nectar.set_value_no_signal(_value)
		Globals.TYPE.ORGANIC:
			progress_organic.set_value_no_signal(_value)
		Globals.TYPE.HONEY:
			progress_honey.set_value_no_signal(_value)
		_:
			#default
			print("Error update progress Resource, no matches on _Type were found : ", _type)

func update_progressbar_factionpower(_faction : Globals.CLASS, _value : int):
	match _faction:
		Globals.CLASS.BEE:
			progress_beepower.set_value_no_signal(_value)
		Globals.CLASS.WASP:
			progress_wasppower.set_value_no_signal(_value)
		Globals.CLASS.HORNET:
			progress_hornetpower.set_value_no_signal(_value)
		_:
			#default
			print("Error update progress FactionPower, no matches on _Type were found : ", _faction)

func _process(_delta):
	if game_ui.current_state ==game_ui.GAME_STATE.RUNNING:
		update_altitude()

func update_altitude():
	#set position  if min 0 and max 100km and if < 1 km show in meters
	altitude_meter.position.y = window_size.y - (player_node.global_position.y / 10000 *window_size.y) + (window_size.y * 0.03)
	altitude_label.text = "%6.3f m" % (player_node.global_position.y / 500)
	if (player_node.global_position.y ) > 1750:
		altitude_label.text = "%4.0f m" % (player_node.global_position.y *10)
		if (player_node.global_position.y) > 5000:
			altitude_label.text = "%3.2f km" % (player_node.global_position.y /100)
			if (player_node.global_position.y) > 10000:
				altitude_label.text = "%3.2f AU" % (player_node.global_position.y)
				if !_lategame:
					_lategame = true
					JobGlobalManager.switch_game_to_late()
