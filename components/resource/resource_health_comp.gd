extends Node
class_name resource_health_component


@export var max_resource_range : Vector2i

var max_resource : float
var current_resource : float


func _ready():
	max_resource  = randf_range(max_resource_range.x, max_resource_range.y)
	current_resource =  max_resource
	set_scale()

func get_damage():
	current_resource -=1
	if current_resource <= 0:
		get_parent().scale = Vector3.ZERO
		get_parent().visible = false
	set_scale()

func set_scale():
	get_parent().scale = Vector3.ONE * (current_resource / max_resource)