extends CharacterBody2D

@export var selected = false
@onready var box = $Selection_box

func _ready():
	set_selected(selected)

func set_selected(value):
	box.visible = value
	#effect ?
