extends Node3D

@onready var timer :Timer = $Timer
@onready var particles : CPUParticles3D = $CPUParticles3D

var max_organic : float
var current_organic : float

var is_collecting : bool = false
var collectors : Array[CharacterBody3D]


func on_area_entered(area : Area3D):
	if collectors.is_empty():
		print("collector empty start timer")
		timer.start()
		particles.global_position.y = area.get_parent().global_position.y
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
		x.get_resource(GAME_RESOURCE.TYPE.ORGANIC)
		
		particles.emitting = true