extends Node2D

@onready var nectar_sprite : Sprite2D =$nectar
@onready var nectar_anim : AnimationPlayer = $resource_anim
@onready var area: Area2D =$Area2D

var bee : CharacterBody2D
var nectar_active : bool = false

func _ready():
	bee = get_parent()
func get_nectar():
	print("get_nectar")
	nectar_active = true
	nectar_sprite.visible = nectar_active
	nectar_anim.play("nectar_wiggle")
	area.monitoring =nectar_active

func hide_nectar():
	nectar_active = false
	area.monitoring =nectar_active
	nectar_sprite.visible = nectar_active
	nectar_anim.stop()


func nectar_collected():
	print("add global nectar")
	JobGlobalManager.increment_job_currency(Globals.RESOURCES.NECTAR)
	hide_nectar()

func _on_area_2d_area_entered(_area:Area2D):

	if !bee.is_transporting_resource:
		bee.start_collecting(bee.Bee_Ressource.NECTAR, _area.get_parent())




func _on_area_2d_area_exited(_area:Area2D):
	print("abort collecting")
	bee.abort_collecting()
