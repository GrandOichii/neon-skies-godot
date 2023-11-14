extends EnemyBehavior

# TODO implement rotation

#
# exports
#

@export var sprite: Sprite2D
@export var on_spotted: String
@export var on_heard_sound: String

#
# methods
#

func eb_physics_process(delta: float):
	super.eb_physics_process(delta)

#
# signal connections
#

func _on_vision_cone_spotted(body: Node2D):
	controller.data['enemy'] = body
	controller.set_state(on_spotted)

func _on_sound_listener_heard_sound(area: Node2D):
	controller.data['sound_area'] = area
	controller.set_state(on_heard_sound)
