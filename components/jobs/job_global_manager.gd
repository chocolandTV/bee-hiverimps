extends Node

class_name job_main_manager

@export var sub_job_handler_water : Sub_job_handler
@export var sub_job_handler_nectar : Sub_job_handler
@export var sub_job_handler_construction : Sub_job_handler
@export var sub_job_handler_guard : Sub_job_handler
@export var sub_job_handler_evolve : Sub_job_handler

# variables 
var job_current_water_currency : float = 0
var job_current_nectar_currency : float = 0
var job_current_construction_currency : float = 0
var job_current_guard_currency : float  = 0
var job_current_evolve_currency : float = 0

func increment_job_currency(_job : int):
	match _job:
		1:
			job_current_water_currency += sub_job_handler_water.get_increment(job_current_water_currency)
			Ui.update_currency_values(0, job_current_water_currency)
		2:
			job_current_nectar_currency += sub_job_handler_nectar.get_increment(job_current_nectar_currency)
			Ui.update_currency_values(1, job_current_nectar_currency)
		3:
			job_current_construction_currency += sub_job_handler_construction.get_increment(job_current_construction_currency)
			Ui.update_currency_values(2, job_current_construction_currency)
		4:
			job_current_guard_currency += sub_job_handler_guard.get_increment(job_current_guard_currency)
			Ui.update_currency_values(3, job_current_guard_currency)
		5:
			job_current_evolve_currency += sub_job_handler_evolve.get_increment(job_current_evolve_currency)
			Ui.update_currency_values(4, job_current_evolve_currency)
		_:
			#default
			print("error cant find a match id: _jobs = ",_job)

