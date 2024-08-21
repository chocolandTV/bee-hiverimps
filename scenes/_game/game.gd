extends Node3D
@export var world_02 : PackedScene
@onready var world_01 : Node3D =$World_01
@export var world_enviroment  : WorldEnvironment

@export var space_enviroment : Environment
@export var directLight : DirectionalLight3D

@export var baum01 : Node3D
@export var baum02 : Node3D
@export var baum03: Node3D

func _ready():
	JobGlobalManager.change_world.connect(change_world)

func change_world():
	#directLight.visible = false
	world_enviroment.environment = space_enviroment
	baum01.visible = false
	baum02.visible = false
	baum03.visible = false
	var instance = world_02.instantiate()
	add_child(instance)
	instance.global_position = Vector3.ZERO