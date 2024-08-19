extends Area3D


func _on_area_entered(area:Area3D):
	print("get triggerd")
	area.get_parent().send_resource()
