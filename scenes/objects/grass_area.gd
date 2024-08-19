extends Node3D

@onready var particles : CPUParticles3D = $CPUParticles3D
@onready var health_component : resource_health_component = $Resource_Health_Comp


func on_area_entered(area : Area3D):
	area.is_working(true, GAME_RESOURCE.TYPE.ORGANIC, self)

func on_area_exited(area : Area3D):
	area.is_working(false, GAME_RESOURCE.TYPE.ORGANIC, self)

func on_collected():
		health_component.get_damage()
		particles.emitting = true