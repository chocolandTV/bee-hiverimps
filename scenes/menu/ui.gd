extends Control

@onready var altitude_meter : PanelContainer =$Altitute_Label
@onready var altitude_label : Label = $Altitute_Label/Label
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


var player_node : CharacterBody3D
var window_size : Vector2  =Vector2 (1920,1080)
func _ready():
	player_node = get_tree().get_nodes_in_group("Player")[0]
	# DisplayServer.window_get_size()
	# windows_size  =  get_viewport().get_visible_rect().size
	window_size = get_viewport().get_window().size * 0.94
	print(window_size)


func update_resource_values(_type : GAME_RESOURCE.TYPE,_value : float):
	match _type:
		GAME_RESOURCE.TYPE.WATER:
			label_resource_water_value.text = str(_value)
		GAME_RESOURCE.TYPE.NECTAR:
			label_resource_nectar_value.text = str(_value)
		GAME_RESOURCE.TYPE.ORGANIC:
			label_resource_organic_value.text= str(_value)
		GAME_RESOURCE.TYPE.HONEY:
			label_resource_honey_value.text = str(_value)
		_:
			#default
			print("Error update Resource_value, no matches on _Type were found : ", _type)

func update_faction_power(_faction : GAME_FACTION.CLASS, _value : int):
	match _faction:
		GAME_FACTION.CLASS.BEE:
			label_faction_beepower_value.text = str(_value)
		GAME_FACTION.CLASS.WASP:
			label_faction_wasppower_value.text = str(_value)
		GAME_FACTION.CLASS.HORNET:
			label_resource_organic_value.text= str(_value)
		_:
			#default
			print("Error update FactionPower _value, no matches on _Type were found : ", _faction)
################################################################################################################


#######  PROGRESS BAR UPDATER

################################################################################################################
func update_progressbar_resource(_type : GAME_RESOURCE.TYPE,_value : float):
	match _type:
		GAME_RESOURCE.TYPE.WATER:
			progress_water.set_value_no_signal(_value)
		GAME_RESOURCE.TYPE.NECTAR:
			progress_nectar.set_value_no_signal(_value)
		GAME_RESOURCE.TYPE.ORGANIC:
			progress_organic.set_value_no_signal(_value)
		GAME_RESOURCE.TYPE.HONEY:
			progress_honey.set_value_no_signal(_value)
		_:
			#default
			print("Error update progress Resource, no matches on _Type were found : ", _type)

func update_progressbar_factionpower(_faction : GAME_FACTION.CLASS, _value : int):
	match _faction:
		GAME_FACTION.CLASS.BEE:
			progress_beepower.set_value_no_signal(_value)
		GAME_FACTION.CLASS.WASP:
			progress_wasppower.set_value_no_signal(_value)
		GAME_FACTION.CLASS.HORNET:
			progress_hornetpower.set_value_no_signal(_value)
		_:
			#default
			print("Error update progress FactionPower, no matches on _Type were found : ", _faction)

func _process(_delta):
	update_altitude()

func update_altitude():
	#set position  if min 0 and max 100km and if < 1 km show in meters
	altitude_meter.position.y = window_size.y - (player_node.global_position.y / 10000 *window_size.y) + (window_size.y * 0.03)
	altitude_label.text = "%6.3f m" % (player_node.global_position.y / 500)
	if (player_node.global_position.y / 500) > 3.5:
		altitude_label.text = "%4.0f m" % (player_node.global_position.y *10)
		if (player_node.global_position.y * 50) > 250000:
			altitude_label.text = "%3.2f km" % (player_node.global_position.y /100)
