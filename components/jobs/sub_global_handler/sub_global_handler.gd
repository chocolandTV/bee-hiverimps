extends Node

class_name Sub_job_handler

@export var sub_job : Job

@export var job_name : String  = "generic_job"
@export var job_level : int  = 1
@export var job_current_users : float = 1
@export var resource_yield : float  = 1
@export var resource_capacity : float  = 10

## currents and wasted

var wasted_currency : float = 0

## Current world base
var current_base
func add_worker(_var : int):
	job_current_users += _var

# functions in class
func get_increment(_current: float) -> float:
	var _value = resource_yield * job_current_users
	if (_current+ _value)  >= resource_capacity:
		return 0
	return _value

func increment_resource_yield():
	resource_yield *= Globals.increment_job_yield

func increment_resource_capacity():
	resource_capacity *= Globals.increment_job_capacity

