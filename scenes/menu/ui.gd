extends Control

@export_category("Currency")
@export var job_water_value : Label
@export var job_nectar_value : Label
@export var job_construction_value: Label
@export var job_guard_value: Label
@export var job_evolve_value : Label



func _ready():
	pass

func update_currency_values(_type : int,_value : float):
	match _type:
		0:
			job_water_value.text = str(_value)
		1:
			job_nectar_value.text = str(_value)
		2:
			job_construction_value.text= str(_value)
		3:
			job_guard_value.text = str(_value)
		4: 
			job_evolve_value.text = str(_value)
		_:
			#default
			print("Error, no matches on _Type were found : ", _type)