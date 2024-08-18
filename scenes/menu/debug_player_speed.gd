extends VBoxContainer

@onready var label_x : Label = $Label_x

var player_node : CharacterBody3D

func _ready():

	player_node = get_tree().get_nodes_in_group("Player")[0]

func _process(_delta):
	if player_node != null:
		updateUI()

func updateUI():
	label_x.text = str("Speed: %d" % player_node.velocity.length_squared())