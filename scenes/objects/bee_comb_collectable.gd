extends Node3D

@onready var timer :Timer = $Timer
@onready var anim : AnimationPlayer = $AnimationPlayer

var max_organic : float
var current_organic : float

var is_collecting : bool = false
var collectors : Array[CharacterBody3D]
var first_collector : bool = false


func on_area_entered(area : Area3D):
	if collectors.is_empty():
		print("collector empty start timer")
		timer.start()
	### add collector
	collectors.append(area.get_parent())

func on_area_exited(area : Area3D):
	### delete collector
	collectors.erase(area.get_parent())

	if collectors.is_empty():
		timer.stop()
		print("stop timer")

func on_timer_timeout():
	for x in collectors:
		if !first_collector:
			JobGlobalManager.add_resource(x.faction, GAME_RESOURCE.TYPE.HONEY, 1)
			anim.play("collected")
			first_collector = true
			# effect animation collected