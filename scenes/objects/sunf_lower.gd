extends Node3D
@export var bee_comb_scene : PackedScene

@onready var particles : CPUParticles3D = $CPUParticles3D
@onready var resource_point: Node3D = $Resource_Point
@onready var health_component : resource_health_component = $Resource_Health_Comp
var max_nectar : float
var current_nectar : float

var current_sunflower_collected : int = 0

func _ready():
	$Nectar_Area.area_entered.connect(on_area_entered)
	$Nectar_Area.area_exited.connect(on_area_exited)

func on_area_entered(area : Area3D):
	area.is_working(true, Globals.RESOURCES.NECTAR, self)

func on_area_exited(area : Area3D):
	area.is_working(false, Globals.RESOURCES.NECTAR, self)

func on_collected():
		health_component.get_damage()
		particles.emitting = true
		current_sunflower_collected += 1
		if current_sunflower_collected >= 100:
			spawn_honey_comb()
			current_sunflower_collected = 0
func spawn_honey_comb():
	var instance = bee_comb_scene.instantiate()
	add_child(instance)
	instance.global_position = resource_point.global_position