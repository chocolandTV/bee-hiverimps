extends TextureRect

var units : int = 0
var is_collecting : bool = false
@export var timer : Timer
@export var particle : CPUParticles2D
@export var next_state : Globals.MENU_STATE
@export var area : Area2D
@export var menu_ui : menu_class
func _ready():
	GameUiManager.button_shooted.connect(on_other_button_shooted)
	area.area_entered.connect(on_area_entered)
	area.area_exited.connect(on_area_exited)
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	if is_collecting:
		print("scaling button")
		scale -= Vector2.ONE * (0.01 * units)

	#### IF BUTTON IS COLLECTED
	if scale <= (Vector2.ONE * 0.01):
		print("BUTTON SHOOT")
		GameUiManager.MENU.set_menu_state(next_state)
		GameUiManager.MENU.on_button_shooted()
		particle.emitting = false
		units = 0
		is_collecting = false

func on_area_entered(_area : Area2D):
	if units == 0:
		timer.start()
		particle.emitting = true

		is_collecting =true
	units += 1

func on_area_exited(_area : Area2D):
	if units <= 1:
		timer.stop()
		particle.emitting = false
		units = 0
		is_collecting = false
	units -= 1

func on_other_button_shooted():
	particle.emitting = false
	units = 0
	is_collecting = false
	scale = Vector2.ONE