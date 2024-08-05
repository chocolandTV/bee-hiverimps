extends Node

@export var resource_yield_factor :float = 1

func _ready():
	$Area2D.resource_yield_factor =resource_yield_factor