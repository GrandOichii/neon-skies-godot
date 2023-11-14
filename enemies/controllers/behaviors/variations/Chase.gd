extends EnemyBehavior
class_name Roam

#
# exports
#

@export var what: String
@export var speed: float
@export var body: CharacterBody2D
@export var sprite: Sprite2D
@export var nav_agent: NavigationAgent2D
@export var on_lost: String

#
# private vars
#

var _active: bool = false
var _target: Node2D = null

#
# methods
#

func _ready():
	call_deferred('_setup_agent')

func eb_start():
	super.eb_start()
	_target = controller.data[what]
	_active = true
	
func eb_stop():
	super.eb_stop()
	_active = false
	
func eb_process(delta: float):
	super.eb_process(delta)

func eb_physics_process(delta: float):
	super.eb_physics_process(delta)

	var loc = nav_agent.get_next_path_position()
	var dir = body.to_local(loc).normalized()

	var vel = dir * speed
	body.velocity = vel
	sprite.look_at(_target.position)
	body.move_and_slide()

#
# signal connections
#

func _setup_agent():
	await get_tree().process_frame # TODO? found online, is ok

func _on_update_path_timer_timeout():
	if not _active or _target == null:
		return
	nav_agent.target_position = _target.global_position

func _on_vision_cone_lost(body: Node2D):
	if _target != body:
		return
	_target = null
	controller.set_state(on_lost)
