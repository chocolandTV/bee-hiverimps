extends Area3D

@onready var timer :Timer  =$Timer
var current_resource : Globals.RESOURCES
var area
func _ready():
	timer.timeout.connect(on_timer_timeout)

func is_working(_value : bool, _type : Globals.RESOURCES, _area):
	current_resource = _type
	area = _area
	if _value:
		timer.start()
	else:
		timer.stop()


func on_timer_timeout():
	if get_parent().is_full_cargo():
		timer.stop()
	else:
		get_parent().get_resource(current_resource)
		area.on_collected()