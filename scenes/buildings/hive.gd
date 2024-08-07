extends StaticBody2D

@onready var box = $Selection_box

var selected : bool = false
var body_radius = 50


func set_selected(value):
	selected = value
	box.visible = value
	#effect ?