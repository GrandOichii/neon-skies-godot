extends EnemyBehavior
class_name StaticInvestigate

#
# exports
#

@export var rot_speed: float = 5
@export var search_radius: float
@export var rot_count: int = 3
@export var wait_between_rot: float = .5
@export var last_spot_var_name: String
@export var on_end: String

#
# private vars
#

var _degree: float
var _rot_count: int
var _initial_rot: float

var _prev_rot_speed: float
var _lp: Vector2

#
# nodes
#

@onready var wait_timer_node: Timer = %WaitTimer

#
# methods
#

func _ready():
	pass

func eb_start():
	super.eb_start()
	_initial_rot = controller.sprite.global_rotation
	_prev_rot_speed = controller.rot_speed
	controller.rot_speed = rot_speed
	
	_rot_count = rot_count
	
	_lp = controller.data[last_spot_var_name].global_position
	controller.rot_target = _lp
	# set rotation target to the last known position of the player + the degree
	# after that decrement the _rot_count and choose a random angle
	# after each angle reaching, wait for a period of time, then decrement the _rot_count and choose another
	# when _rot_count reaches zero, change state
	
func eb_stop():
	super.eb_stop()
	controller.rot_speed = _prev_rot_speed
	
	if not wait_timer_node.is_stopped():
		wait_timer_node.stop()
		
func eb_physics_process(delta: float):
	super.eb_physics_process(delta)
	
	if not wait_timer_node.is_stopped():
		return
	
	controller.rotate_towards_target(delta)
	if controller.reached_rotation():
		wait_timer_node.start(wait_between_rot)

#
# signal connections
#

func _on_wait_timer_timeout():
	# update target
	_rot_count -= 1
	if _rot_count <= 0:
		controller.current_state = on_end
		return
	controller.rot_target = Vector2(
		_lp.x + randi_range(0, search_radius) / 2,
		_lp.y + randi_range(0, search_radius) / 2,
	)
#	var rot = randf_range(_initial_rot - _degree / 2, _initial_rot + _degree / 2)
#	rot = _initial_rot
##	var rot = lerp_angle(_initial_rot - _degree / 2, _initial_rot + _degree / 2, randf())
#	print(_initial_rot, ' ', rot)
#	controller.rot_target = controller.global_position + Vector2(100, 0).rotated(rot)

func _on_sound_listener_heard_sound(area: Area2D):
	controller.data[last_spot_var_name] = area
	controller.current_state = state
