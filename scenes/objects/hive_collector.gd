extends Area3D
func _on_area_entered(area:Area3D):
	if area.get_parent().faction == get_parent().get_parent().current_faction:
		area.get_parent().send_resource()
	elif area.get_parent().faction != get_parent().get_parent().current_faction:
		print("different faction, cant give resource here")
		GameUiManager.UI.set_player_info_box("Different faction, cant give resource here")
