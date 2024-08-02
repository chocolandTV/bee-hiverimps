extends Resource

class_name Job
# EDITABLE NEW JOB CLASS
@export var job_name : String  = "generic_job"
@export var job_level : int  = 1
@export var job_current_users : int = 0
@export var base_job_resource_yield : float  = 0
@export var base_job_reource_capacity : int  = 10

# PERCENT UPGRADE GATHER YIELD AND CAPACITY 100 = 100% yield e.g 200% is 2x
var percent_upgrade_job_gather : int = 100
var percent_upgrade_job_capacity : int = 100

## currents and wasted
var current_job_currency : int = 0
var wasted_job_currentcy : int = 0

## current ui variables 
var ui_current_resoruce_yield : float  = 0
var ui_current_time_until_capacity_is_full :float = 0
