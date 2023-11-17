extends EnemyBehavior

#
# exports
#

@export var attack_controller: AttackController
@export var body: Node2D
@export var lost_target_state: String
@export var target_lost_timeout: float

#
# nodes
#

@onready var keep_looking_timer_node: Timer =  %KeepLookingTimer

#
# private vars
#

# TODO? change type
var _enemy: Node2D
var _lost: bool = false
var _last_known_position: Vector2

#
# methods
#

func _ready():
	keep_looking_timer_node.wait_time = target_lost_timeout

func eb_start():
	super.eb_start()
	_lost = false
	
	_enemy = controller.data['enemy'] as Node2D
	
func eb_stop():
	super.eb_stop()
	
func eb_process(delta: float):
	super.eb_process(delta)
	
	var target = _last_known_position
	if not _lost:
		target = _enemy.position
		_last_known_position = target
		attack_controller.fire()
	body.look_at(target)

#
# signal connections
#

func _on_look_for_enemy_lost_target():
	_lost = true
	keep_looking_timer_node.start()

func _on_keep_looking_timer_timeout():
	controller.current_state = lost_target_state

func _on_look_for_enemy_found_target():
	controller.current_state = state
