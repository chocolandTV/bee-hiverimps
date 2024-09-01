extends TextureRect
@export var timer : Timer
@export var particle : CPUParticles2D
@export var next_state : Globals.MENU_STATE
@export var unit_panel : Panel
@export var menu_ui : menu_class
var mouse_position : Vector2 = Vector2.ZERO
var temp_count : int = 0
var offset_texture : Vector2 = Vector2(128,128)
func _ready():
	GameUiManager.button_shooted.connect(on_other_button_shooted)
	timer.timeout.connect(on_timer_timeout)
	GameUiManager.game_paused.connect(on_game_paused)
	GameUiManager.game_started.connect(on_game_started)
	GameUiManager.game_resume.connect(on_game_resumed)
	on_game_paused()
func _input(event):
	if event.is_action_pressed("left_click"):
		mouse_position = get_global_mouse_position()

func on_timer_timeout():
	temp_count =units_in_range()
	print(mouse_position)
	print(global_position)
	if temp_count >=3 and mouse_position.distance_to(global_position+ offset_texture) < 250:
		scale -= Vector2.ONE * (0.1)
	#### IF BUTTON IS COLLECTED
	if scale <= (Vector2.ONE * 0.03):
		GameUiManager.MENU.set_menu_state(next_state)
		GameUiManager.on_button_shooted()
		particle.emitting = false

func on_other_button_shooted():
	######## AFTER EMMITING
	print("on_button_shooted")
	particle.emitting = false
	scale = Vector2.ONE


func units_in_range() -> int:
	var count : int = 0
	for x in unit_panel.units:
		if (global_position+offset_texture).distance_to(x.position) <250:
			count +=1
	return count
func on_game_started():
	timer.stop()

func on_game_resumed():
	timer.stop()

func on_game_paused():
	######## ON START MENU
	particle.emitting = false
	scale = Vector2.ONE
	timer.start()