extends StaticBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var box = $Selection_box
var selected : bool = false
var body_radius : float = 30

func _on_nectar_area_body_exited(_body:Node2D):
	anim.play("give_nectar")

func _on_nectar_area_body_entered(_body:Node2D):
	anim.stop()

func set_selected(value):
	selected = value
	box.visible = value
	#effect ?