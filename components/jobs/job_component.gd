extends Node

@export var current_job : Globals.JOBS = Globals.JOBS.IDLE
# need for Movement_component
@onready var trigger_area : Area2D =$Area2D
@onready var timer : Timer = $Timer
var current_base

var collecting : bool = false
func _ready():
	change_trigger_area_mask()
	timer.timeout.connect(on_timer_timeout)

func change_current_job( _value : Globals.JOBS):
	current_job = _value
	change_trigger_area_mask()
	#update ui
	#update path

func change_current_job_location(_newBase):
	current_base = _newBase

func change_trigger_area_mask():
	trigger_area.set_collision_mask_value(5,false)
	trigger_area.set_collision_mask_value(6,false)
	trigger_area.set_collision_mask_value(7,false)
	trigger_area.set_collision_mask_value(8,false)
	trigger_area.set_collision_mask_value(9,false)
	## turn all off
	trigger_area.set_collision_mask_value(current_job, true)


func _on_area_2d_area_entered(_area:Area2D):
	if current_job == _area.job:
		print("AREA DETECTED")
		collecting = true
		change_current_job_location(_area)

func _on_area_2d_area_exited(_area:Area2D):
	if current_job == _area.job:
		collecting = false
		current_base = null

func on_timer_timeout():
	if collecting:
		## add current job increment currency
		JobGlobalManager.increment_job_currency(current_job)