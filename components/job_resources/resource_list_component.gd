extends Node3D
class_name resource_list_component

var player : Node3D
var resource_list: Array[Node3D]
signal deleted_resource_point()
func get_player_node():
	return player
func get_random_resource():
	return resource_list.pick_random()

################### SET DATA #####################
func update_resource_list():
	var _reource_points = get_tree().get_nodes_in_group("resource_point")
	for x in _reource_points:
		resource_list.append(x)

	print(resource_list.size())

func delete_resource(node : Node3D):
	resource_list.erase(node)
	deleted_resource_point.emit()
	
	node.get_parent().queue_free()

func update_player_node(_value : Node3D):
	player = _value