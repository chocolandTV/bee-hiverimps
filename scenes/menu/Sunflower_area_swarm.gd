extends Area2D


func _on_area_entered(area:Area2D):
	area.get_parent().on_nectar_set(true)
