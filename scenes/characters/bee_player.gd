extends CharacterBody3D
@export var speed := 35.0
@export var fly_speed := 1.0

# For smoother controller/mouse movement
@export var acceleration := 3.5
@export var acceleeration_damping := 0.5
@export var faction : GAME_FACTION.CLASS
# Mouse sensitivity for look around
@export var mouse_sensitivity := 0.6
@export var camera : Camera3D
@export var clamp_angle : Vector2 = Vector2(-45, 45)
@onready var bee_mesh : Node3D = $mainBee
@onready var anim : AnimationPlayer = $mainBee/AnimationPlayer
@export var particle : CPUParticles3D
#CONST
const STRAFE_DAMPING : float = 0.75
#move_towards
var current_acceleration :float = 0.0

var move_direction : Vector3
##### ITEM VARS
var items : Dictionary ={
    "water":0,
    "nectar" : 10,
    "organic":0,
    "honey" : 0
}
var max_items : int = 1
var item_count : int = 0
######### mouse data
var last_mouse_relative : Vector2
## get difference from mouse motion
var mouse_relative : Vector2
var fly_relative : float

####### rotate_towards
var current_rotation_x : float = 0
var current_rotation_y : float = 0

#### Directions 
var input_direction : Vector2
var look_direction : Vector2 
var fly_direction : float = 0.0

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    JobGlobalManager.increase_unit_upgrade.connect(on_upgrade)
    JobGlobalManager.change_world.connect(on_world_change)
    ResourceListComponent.update_player_node(self)
    ResourceListComponent.update_resource_list()

func on_world_change():
    global_position = Vector3.ZERO
    velocity = Vector3.ZERO
    item_count = 0
    items["water"] = 0
    items["nectar"] = 0
    items["organic"] =0
    items["honey"] =0

func _input(event):
    input_direction = Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
    if event.is_action_pressed("move_up"):
        fly_relative = 1
    if event.is_action_released("move_up"):
        fly_relative = 0
    if event.is_action_pressed("move_down"):
        fly_relative = -1
    if event.is_action_released("move_down"):
        fly_relative = 0

    if event is InputEventMouseMotion:
        #get new mouseposition
        mouse_relative = event.relative

func _process(_delta):
    bee_mesh.rotate_y(-mouse_relative.x * (mouse_sensitivity / 1000))
    if input_direction.length() ==0:
        anim.play("idle")
    else:
        anim.play("flying")

func _physics_process(_delta):
    if input_direction.length() !=0 or fly_relative != 0:
        current_acceleration  = move_toward(current_acceleration, acceleration,  acceleeration_damping * _delta)
    else:
        current_acceleration  = move_toward(current_acceleration, 0, acceleeration_damping *  _delta)

    move_direction = Vector3(input_direction.x * STRAFE_DAMPING,fly_relative *fly_speed, input_direction.y)
    move_direction = move_direction.rotated(Vector3.UP, bee_mesh.rotation.y)
    velocity = velocity.move_toward(move_direction* speed, current_acceleration)
    move_and_slide()

func get_resource(_resource : GAME_RESOURCE.TYPE):
    if  item_count >= (max_items):
        particle.emitting = true
        return #### later drop nectar
    if _resource == GAME_RESOURCE.TYPE.WATER:
        items["water"] += 1
        item_count += 1
        Ui.update_player_backpack(GAME_RESOURCE.TYPE.WATER,items["water"])
    if _resource == GAME_RESOURCE.TYPE.NECTAR:
        items["nectar"] += 1
        item_count += 1
        Ui.update_player_backpack(GAME_RESOURCE.TYPE.NECTAR,items["nectar"])
    if _resource == GAME_RESOURCE.TYPE.ORGANIC:
        items["organic"] +=1
        item_count += 1
        Ui.update_player_backpack(GAME_RESOURCE.TYPE.ORGANIC,items["organic"])
    if _resource == GAME_RESOURCE.TYPE.HONEY:
        items["honey"] +=1
        item_count += 1
        Ui.update_player_backpack(GAME_RESOURCE.TYPE.HONEY,items["honey"])


func send_resource():

    JobGlobalManager.add_resource(faction, GAME_RESOURCE.TYPE.WATER, items["water"])
    JobGlobalManager.add_resource(faction, GAME_RESOURCE.TYPE.NECTAR, items["nectar"])
    JobGlobalManager.add_resource(faction, GAME_RESOURCE.TYPE.ORGANIC, items["organic"])
    JobGlobalManager.add_resource(faction, GAME_RESOURCE.TYPE.HONEY, items["honey"])

    item_count = 0
    items["water"] = 0
    items["nectar"] = 0
    items["organic"] =0
    items["honey"] =0
    Ui.clear_player_backpack()
    particle.emitting = false

func on_upgrade(_faction, _value):
    if(_faction == faction):
        max_items += _value
        speed += _value
        fly_speed += (_value /10)