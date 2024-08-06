extends Node
class_name Nectar_Component
@onready var nectar_sprite : Sprite2D =$nectar
@onready var nectar_anim : AnimationPlayer = $resource_anim
@onready var area: Area2D =$Area2D

var nectar_active : bool = false
func get_nectar():
	nectar_active = true
	nectar_sprite.visible = nectar_active
	nectar_anim.play("nectar_wiggle")
	area.monitoring =nectar_active

func hide_nectar():
	nectar_active = false
	area.monitoring =nectar_active
	nectar_sprite.visible = nectar_active
	nectar_anim.stop()


func collect_nectar():
	JobGlobalManager.increment_job_currency(Globals.JOBS.NEKTAR)
	hide_nectar()