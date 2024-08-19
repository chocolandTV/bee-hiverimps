extends Node3D
@export var bee_comb_scene : PackedScene

@onready var timer :Timer = $Timer
@onready var particles : CPUParticles3D = $CPUParticles3D
@onready var resource_point: Node3D = $Resource_Point
var max_nectar : float
var current_nectar : float

var current_sunflower_collected : int = 0

var collectors : Array[CharacterBody3D]

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
			#JobGlobalManager.add_resource(x.fraction, GAME_RESOURCE.TYPE.NECTAR)
		x.get_resource(GAME_RESOURCE.TYPE.NECTAR)
		print("collected Nectar")
		particles.emitting = true
		current_sunflower_collected += 1
		if current_sunflower_collected >= 100:
			spawn_honey_comb()
			current_sunflower_collected = 0
func spawn_honey_comb():
	var instance = bee_comb_scene.instantiate()
	add_child(instance)
	instance.global_position = resource_point.global_position