extends EnemyBehavior
class_name InvestigateBehavior

#
# exports
#

@export var react_after: float = 0
@export var consider_reached_distance: float
@export var on_reached_point: String

#
# private vars
#

#
# methods
#

func eb_start():
	super.eb_start()
	
	controller.move_target = controller.data['sound_area'].global_position

func eb_physics_process(delta: float):
	controller.move_towards_target()
	if controller.nav_agent.is_target_reached() or controller.nav_agent.distance_to_target() < consider_reached_distance:
		controller.reset_target()
		controller.set_state(on_reached_point)

#
# signal connections
#

func _on_sound_listener_heard_sound(area: Area2D):
	controller.move_target = area.global_position
