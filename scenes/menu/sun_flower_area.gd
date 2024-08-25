extends Area2D

var is_active : bool = false
var county : int  =0
@onready var particle :CPUParticles2D =$sunflower_Particles
func _on_area_exited(_area:Area2D):
	if county == 0:
		is_active = true
		particle.emitting = true
	county +=1

func _on_area_entered(_area:Area2D):
	if county <= 1:
		is_active = false
		particle.emitting = false
	county =0
