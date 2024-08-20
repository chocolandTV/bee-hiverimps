extends PanelContainer

func on_win_menu(_value : bool):
	if _value:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible=(_value)