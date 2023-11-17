extends EnemyBehavior
class_name InvestigateBehavior

#
# exports
#

@export var speed: float
# TODO not in use currently
@export var react_after: float = 0
@export var stay_for: float
@export var on_reached_point: String

#
# nodes
#

@onready var wait_timer_node: Timer = %WaitTimer

#
# private vars
#

#
# methods
#

func eb_start():
	super.eb_start()
	
	controller.speed = speed
	
	controller.move_target = controller.data['sound_area'].global_position

func eb_stop():
	super.eb_stop()
	if not wait_timer_node.is_stopped():
		wait_timer_node.stop()

func eb_physics_process(delta: float):
	if not wait_timer_node.is_stopped():
		return
	
	controller.move_towards_target(delta)
	if controller.reached_target():
		if stay_for <= 0:
			_end()
			return
		wait_timer_node.wait_time = stay_for
		wait_timer_node.start()

func _end():
	controller.reset_target()
	controller.current_state = on_reached_point

#
# signal connections
#

func _on_sound_listener_heard_sound(area: Area2D):
	controller.data['sound_area'] = area
	controller.current_state = state

func _on_wait_timer_timeout():
	_end()
