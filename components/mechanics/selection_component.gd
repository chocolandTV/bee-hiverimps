extends Node
class_name Selection_Component


var units = []
func _ready():
	units = get_tree().get_nodes_in_group("units")

func on_area_selected(_object):
	var start = _object.start
	var end = _object.end
	var area = []
	area.append(Vector2(min(start.x,end.x),min(start.y, end.y)))
	area.append(Vector2(max(start.x,end.x), max(start.y,end.y)))
	var _ut = get_units_in_area(area)
	#deselect
	for _unit in units:
		_unit.set_selected(false)
	#select in area
	for _unit in _ut:
		_unit.set_selected(!_unit.selected)


func get_units_in_area(area):
	var area_units = []
	for unit in units:
		if (unit.position).distance_to(area[0])< unit.body_radius:
			area_units.append(unit)
		elif (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if(unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				area_units.append(unit)
	return area_units