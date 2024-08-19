extends Area3D

@onready var timer :Timer  =$Timer
var current_resource : GAME_RESOURCE.TYPE
var area
func _ready():
	pass

func is_working(_value : bool, _type : GAME_RESOURCE.TYPE, _area):
	current_resource = _type
	area = _area
	if _value:
		timer.start()
	else:
		timer.stop()


func on_timer_timeout():
	get_parent().get_resource(current_resource)
	area.on_collected()