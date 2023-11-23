extends EnemyBehavior

# TODO implement rotation

#
# exports
#

@export var from_angle: float = 0
@export var to_angle: float = 180
@export var rot_speed: float = 1
@export var wait_when_reached: float = 1

@export var sprite: Sprite2D
@export var on_spotted: String
@export var on_heard_sound: String

#
# nodes
#

@onready var wait_timer_node: Timer = %WaitTimer

#
# private vars
#

var _fa: float
var _ta: float

var _prev_rot_speed: float
var _current: float

#
# methods
#

func _ready():
	_fa = deg_to_rad(from_angle)
	_ta = deg_to_rad(to_angle)

func eb_physics_process(delta: float):
	super.eb_physics_process(delta)
	
	if not wait_timer_node.is_stopped():
		return
	
	controller.rotate_towards_target(delta)
	if controller.reached_rotation():
		if wait_when_reached > 0:
			wait_timer_node.start(wait_when_reached)
			return
		_update_rot_target()

func eb_start():
	super.eb_start()
	_prev_rot_speed = controller.rot_speed
	controller.rot_speed = rot_speed
	
	_update_rot_target()
	
func _update_rot_target():
	_current = _fa if _current == _ta else _ta
	controller.rot_target = controller.global_position + Vector2(100, 0).rotated(_current)

func eb_stop():
	super.eb_stop()
	controller.rot_speed = _prev_rot_speed
	if not wait_timer_node.is_stopped():
			wait_timer_node.stop()
#
# signal connections
#

func _on_vision_cone_spotted(body: Node2D):
	controller.data['enemy'] = body
	controller.current_state = on_spotted

func _on_sound_listener_heard_sound(area: Node2D):
	controller.data['sound_area'] = area
	controller.current_state = on_heard_sound

func _on_wait_timer_timeout():
	_update_rot_target()
