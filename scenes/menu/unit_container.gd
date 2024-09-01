extends Panel
var units : Array[CharacterBody2D]



func _ready():
	for _i in self.get_children():
		units.append(_i)