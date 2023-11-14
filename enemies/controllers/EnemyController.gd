extends Node
class_name EnemyController

#
# exports
#

@export var initial_state: String

#
# nodes
#

@onready var behaviors_container: Node = %Behaviors

#
# vars
#

var data: Dictionary = {}

#
# private vars
#

var _behaviors: Dictionary = {}
var _current: String = ''

#
# methods
#

func _ready():
	for b in behaviors_container.get_children():
		var beh = b as EnemyBehavior
		beh.controller = self
		_behaviors[beh.state] = beh
		
	set_state(initial_state)
	
func _process(delta):
	_behaviors[_current].eb_process(delta)
	
func _physics_process(delta):
	_behaviors[_current].eb_physics_process(delta)

func set_state(state: String):
	if _current.length() != 0:
		_behaviors[_current].eb_stop()
	_current = state
	_behaviors[_current].eb_start()
