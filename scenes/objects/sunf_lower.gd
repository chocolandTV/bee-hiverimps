extends Node3D

@onready var timer :Timer = $Timer
var max_nectar : float
var current_nectar : float

var current_sunflower_state: int
#### states: 0 is full of resource
#### 1 is lose some >75%
#### 2 > 50%
#### 3 > 25%
#### 4 = 0%

var is_collecting : bool = false
var collectors : Array[CharacterBody3D]
func set_state():
	pass

func give_nectar():
	var nectar_step = 1
	return nectar_step

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
		JobGlobalManager.add_resource(x.fraction, GAME_RESOURCE.TYPE.NECTAR)