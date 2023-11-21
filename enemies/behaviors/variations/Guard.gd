extends EnemyBehavior

# TODO implement rotation

#
# exports
#

@export var from_angle: float = 0
@export var to_angle: float = 180
@export var rot_speed: float = 1

@export var sprite: Sprite2D
@export var on_spotted: String
@export var on_heard_sound: String

#
# methods
#

func eb_physics_process(delta: float):
	super.eb_physics_process(delta)
	
	
	
func eb_start():
	super.eb_start()
	

#
# signal connections
#

func _on_vision_cone_spotted(body: Node2D):
	controller.data['enemy'] = body
	controller.current_state = on_spotted

func _on_sound_listener_heard_sound(area: Node2D):
	controller.data['sound_area'] = area
	controller.current_state = on_heard_sound
