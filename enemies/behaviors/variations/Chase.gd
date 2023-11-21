extends EnemyBehavior
class_name Roam

#
# exports
#

@export var what: String
@export var speed: float
@export var stop_range: float

@export_group('Attacking')
@export var attack_range: float
@export var attack_controller: AttackController

@export_group('Lost target')
@export var on_lost: String
@export var last_pos_var_name: String

#
# private vars
#

var _active: bool = false
var _target: Node2D = null

#
# methods
#

func _ready():
	pass

func eb_start():
	super.eb_start()
	
	controller.speed = speed
	
	_target = controller.data[what]
	controller.move_target = _target.global_position
	controller.rot_with_move = false
	_active = true
	
func eb_stop():
	super.eb_stop()
	controller.rot_with_move = true
	_active = false
	
func eb_process(delta: float):
	super.eb_process(delta)

func eb_physics_process(delta: float):
	super.eb_physics_process(delta)
	
	controller.rot_target = _target.global_position
	controller.rotate_towards_target(delta)

	var distance = controller.global_position.distance_to(_target.global_position)
	if distance < attack_range:
		_attack()
	controller.sprite.look_at(_target.position)
	if distance < stop_range:
		return
	controller.move_towards_target(delta)
	
func _attack():
	attack_controller.fire()

#
# signal connections
#

func _on_update_path_timer_timeout():
	if not _active or _target == null:
		return
	controller.move_target = _target.global_position

func _on_vision_cone_lost(b: Node2D):
	if _target != b:
		return
	controller.data[last_pos_var_name] = _target
	_target = null
	controller.current_state = on_lost

func _on_vision_cone_spotted(body: Node2D):
	if controller.current_state == state:
		return
	controller.data[what] = body
	controller.current_state = state
