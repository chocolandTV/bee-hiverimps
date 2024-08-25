extends VBoxContainer

@onready var label_x : Label = $Label_x

var player_node : CharacterBody3D = null
func _ready():
	pass
func set_player(value: CharacterBody3D):

	player_node = value

func _process(_delta):
	if player_node != null:
		updateUI()

func updateUI():
	label_x.text = str("Speed: %d" % (player_node.velocity.length_squared()/100))