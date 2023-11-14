extends EnemyBehavior

# TODO implement rotation

#
# exports
#

@export var sprite: Sprite2D
@export var on_spotted: String

#
# private vars
#

var _target: Node2D

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
