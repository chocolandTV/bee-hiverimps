extends Node

enum JOBS {
	WATER = 5,
	NEKTAR = 6,
	CONSTRUCTION = 7,
	GUARD = 8,
	EVOLVE = 9,
	IDLE = 0
}
@export var increment_job_yield : float = 1.1
@export var increment_job_capacity : float = 2.0

@export var increment_job_costs : float = 2.0