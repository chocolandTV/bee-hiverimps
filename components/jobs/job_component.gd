extends Node

@export var job_list : Array[Job]

var current_job : Job = null



func change_current_job( _value : Job):
	current_job = _value
	#update ui
	#update path
