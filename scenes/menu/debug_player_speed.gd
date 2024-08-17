extends VBoxContainer

@onready var label_x : Label = $Label_x
@onready var label_y : Label = $Label_y
@onready var label_z : Label = $Label_z

var player_node : CharacterBody3D

func _ready():

	player_node = get_tree().get_nodes_in_group("Player")[0]

func _process(_delta):
	if player_node != null:
		updateUI()

func updateUI():
	label_x.text = str(player_node.velocity.x)
	label_y.text = str(player_node.velocity.y)
	label_z.text = str(player_node.velocity.z)