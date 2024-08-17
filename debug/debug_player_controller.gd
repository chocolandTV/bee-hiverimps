extends CharacterBody3D

class_name ShipController

var _is_player : bool = false
var _is_controlled : bool = false
var _input : Vector3 = Vector3()
var _is_gamepad_scheme : bool = false
var _look_point : Vector2 = Vector2()
var _look_input : Vector2 = Vector2()
var _rigidbody : RigidBody
var _thrusters : Dictionary = {}
var _thruster_force : Vector3 = Vector3()
var _is_breaking : bool = false

@export var _thruster_prefab : PackedScene
@export var _player_seat : Node
@export var _player_bot : ShipController
var _player_settings : Dictionary
var _thrust_indicator : Node
var _speed_indicator : Node
var _player_interaction : Node
var _mouse_sensitivity : float = 0.0
var _gamepad_sensitivity : float = 0.0

func _ready():
    _rigidbody = $RigidBody
    InitThrusterArrays()
    if _is_player:
        InitWithThrusters()
        SetControlled(true)

    SubcribeToInput()
    _player_settings = RefManager.game_manager._player_settings
    _thrust_indicator = RefManager.thrust_indicator
    _speed_indicator = RefManager.speed_indicator
    RefManager.settings_manager.connect("OnGamepadSensitivityChanged", self, "_on_gamepad_sens_change")
    RefManager.settings_manager.connect("OnMouseSensitivityChanged", self, "_on_mouse_sens_change")
    _on_gamepad_sens_change(5)
    _on_mouse_sens_change(5)

func InitThrusterArrays():
    var layout = $ConnectorLayout
    _thrusters["default"] = []
    _thrusters["up"] = Array.new(layout.up.size())
    _thrusters["down"] = Array.new(layout.down.size())
    _thrusters["left"] = Array.new(layout.left.size())
    _thrusters["right"] = Array.new(layout.right.size())
    _thrusters["forward"] = Array.new(layout.forward.size())
    _thrusters["backward"] = Array.new(layout.backward.size())

func AddThruster(thruster, dir, id):
    _thrusters[dir][id] = thruster

func HandleDisconnect(dir, id, connectable):
    _thrusters[dir][id] = null

func InitWithThrusters():
    _thrusters["up"][0] = _thruster_prefab.instance()
    add_child(_thrusters["up"][0])
    _thrusters["up"][0].Connect("up", 0, self)

    _thrusters["down"][0] = _thruster_prefab.instance()
    add_child(_thrusters["down"][0])
    _thrusters["down"][0].Connect("down", 0, self)

    _thrusters["left"][0] = _thruster_prefab.instance()
    add_child(_thrusters["left"][0])
    _thrusters["left"][0].Connect("left", 0, self)

    _thrusters["right"][0] = _thruster_prefab.instance()
    add_child(_thrusters["right"][0])
    _thrusters["right"][0].Connect("right", 0, self)

    _thrusters["forward"][0] = _thruster_prefab.instance()
    add_child(_thrusters["forward"][0])
    _thrusters["forward"][0].Connect("forward", 0, self)

    _thrusters["backward"][0] = _thruster_prefab.instance()
    add_child(_thrusters["backward"][0])
    _thrusters["backward"][0].Connect("backward", 0, self)

func _process(delta):
    _look_input = _look_input.move_toward(_look_point, 0.1)
    if not _is_gamepad_scheme:
        _look_point = _look_point.move_toward(Vector2.ZERO, _player_settings["mousePointDrag"] * delta)

    var angle_x = rotation.x
    var angle_y = rotation.y

    angle_x -= _look_input.y * _player_settings["cameraSensitivity"]
    angle_x = clamp(angle_x, -85, 85)
    angle_y = angle_y + _look_input.x * _player_settings["cameraSensitivity"]

    var new_rotation = Vector3(angle_x, angle_y, 0)
    _rigidbody.rotation = new_rotation

    if _is_player and not _is_controlled:
        global_transform.origin = _player_seat.global_transform.origin
        global_transform.basis = _player_seat.global_transform.basis

func _physics_process(delta):
    _thruster_force = HandleThrusters()
    _rigidbody.apply_impulse(Vector3.ZERO, _thruster_force)
    
    if _is_breaking:
        _rigidbody.angular_velocity = _rigidbody.angular_velocity.move_toward(Vector3.ZERO, _player_settings["angularBreakingPower"])
        if _rigidbody.linear_velocity.length() < _player_settings["breakingStopPoint"]:
            _rigidbody.linear_velocity = Vector3.ZERO

    if _is_controlled:
        _thrust_indicator.VelocityVector = -_input
        _thrust_indicator.IsBreaking = _is_breaking
        _speed_indicator.VelocityVector = global_transform.basis.xform_inv(_rigidbody.linear_velocity) * 0.1

func HandleThrusters() -> Vector3:
    var x_val = 0.0
    var y_val = 0.0
    var z_val = 0.0

    var temp_input = _input
    if _is_breaking:
        temp_input = _rigidbody.linear_velocity
        temp_input = temp_input.clamped(1)

    var curr_input = clamp(temp_input.y, -1, 0)
    for thruster in _thrusters["down"]:
        if thruster != null:
            thruster.SetTargetStrength(-curr_input)
            y_val += thruster.CurrentStrength

    curr_input = clamp(temp_input.y, 0, 1)
    for thruster in _thrusters["up"]:
        if thruster != null:
            thruster.SetTargetStrength(curr_input)
            y_val -= thruster.CurrentStrength

    curr_input = clamp(temp_input.x, -1, 0)
    for thruster in _thrusters["left"]:
        if thruster != null:
            thruster.SetTargetStrength(-curr_input)
            x_val += thruster.CurrentStrength

    curr_input = clamp(temp_input.x, 0, 1)
    for thruster in _thrusters["right"]:
        if thruster != null:
            thruster.SetTargetStrength(curr_input)
            x_val -= thruster.CurrentStrength

    curr_input = clamp(temp_input.z, -1, 0)
    for thruster in _thrusters["backward"]:
        if thruster != null:
            thruster.SetTargetStrength(-curr_input)
            z_val += thruster.CurrentStrength

    curr_input = clamp(temp_input.z, 0, 1)
    for thruster in _thrusters["forward"]:
        if thruster != null:
            thruster.SetTargetStrength(curr_input)
            z_val -= thruster.CurrentStrength

    var result = Vector3(x_val, y_val, z_val)
    if not _is_breaking:
        result = global_transform.basis.xform(result)

    return result

func SetControlled(is_controlled: bool):
    _is_controlled = is_controlled

func OnMoveInput(context):
    if _is_controlled:
        var input = context.get_action_strength("move")
        _input = Vector3(-input.x, _input.y, -input.y)

func OnVerticalMovement(context):
    if _is_controlled and not context.is_action_just_pressed("vertical_move"):
        var input = context.get_action_strength("vertical_move")
        _input = Vector3(_input.x, -input, _input.z)

func OnBreakInput(context):
    if _is_controlled:
        if context.is_action_pressed("break"):
            _is_breaking = true
        elif context.is_action_released("break"):
            _is_breaking = false
            if _rigidbody.linear_velocity.length() < _player_settings["breakingStopPoint"]:
                _rigidbody.linear_velocity = Vector3.ZERO

func OnLookInput(context):
    if _is_controlled:
        if _is_gamepad_scheme:
            _look_point = context.get_vector2() * _gamepad_sensitivity
        else:
            var curr_input = context.get_vector2().clamped(0.05) * _player_settings["mouseMultiplier"] * _mouse_sensitivity
            _look_point = (_look_point + curr_input).clamped(1)

func _on_destroy():
    if RefManager.ship_controller == self:
        RefManager.ship_controller = null
    UnSubscibeToInput()

func Interact():
    if not _is_player:
        _player_bot.global_transform.origin = _player_seat.global_transform.origin
        _player_bot.global_transform.basis = _player_seat.global_transform.basis
        _player_bot.set_parent(_player_seat)
        _player_bot._is_controlled = false
        _player_bot.TakeASeat()
        _player_bot._rigidbody.mode = RigidBody.MODE_KINEMATIC
        $SphereCollider.disabled = true
        yield(get_tree().create_timer(0.2), "timeout")
        _is_controlled = true

func GetInteractText() -> String:
    return "Enter Ship"

func OnControlSchemeChanged(is_gamepad_now: bool):
    _is_gamepad_scheme = is_gamepad_now

func _on_gamepad_sens_change(val: float):
    _gamepad_sensitivity = val * 100 * 0.01

func _on_mouse_sens_change(val: float):
    _mouse_sensitivity = val * 100 * 0.01
