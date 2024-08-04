extends Camera2D

@onready var panel : Panel = get_node("../Panel")
var mouse_pos = Vector2()

var mouse_global_position = Vector2()

var start = Vector2()
var start_v = Vector2()
var end = Vector2()
var end_v = Vector2()

var isDragging : bool = false

signal area_selected()
signal start_move_selection()


func draw_area(s =true):
	panel.size = Vector2(abs(start_v.x - end_v.x), abs(start_v.y - end_v.y))

	var pos = Vector2()
	pos.x = min(start_v, end_v.x)
	pos.y = min(start_v.y,end_v.y)
	panel.position = pos
	panel.size *= int(s)