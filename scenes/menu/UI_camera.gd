extends Camera2D

@export var selection_component : Selection_Component

@onready var panel : Panel = get_node("../UI/Drag_Box_Panel")
var mouse_pos = Vector2()

var mouse_global_position = Vector2()

var start = Vector2()
var start_v = Vector2()
var end = Vector2()
var end_v = Vector2()

var isDragging : bool = false

signal area_selected()
signal start_move_selection()
func _ready():
	connect("area_selected", Callable(selection_component, "on_area_selected"))
func _input(event):
	if event is InputEventMouse:
		mouse_pos = event.position
		mouse_global_position = get_global_mouse_position()
func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		start = mouse_global_position
		start_v = mouse_pos

		isDragging = true
	if isDragging:
		end = mouse_global_position
		end_v = mouse_pos
		draw_area()


	if Input.is_action_just_released("left_click"):
		if start_v.distance_to(mouse_pos) > 20:
			end = mouse_global_position
			end_v = mouse_pos
			isDragging =false
			draw_area(false)
			emit_signal("area_selected",self)
		else:
			end = start
			isDragging = false
			draw_area(false)


func draw_area(s =true):
	panel.size = Vector2(abs(start_v.x - end_v.x), abs(start_v.y - end_v.y))

	var pos = Vector2()
	pos.x = min(start_v.x, end_v.x)
	pos.y = min(start_v.y,end_v.y)
	panel.position = pos
	panel.size *= int(s)
