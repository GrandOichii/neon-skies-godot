extends Node
class_name EnemyBehavior

#
# exports
#

@export var state: String

#
# vars
#

var controller: EnemyController

#
# methods
#

func eb_start():
	pass
	
func eb_stop():
	pass
	
func eb_process(_delta: float):
	pass
	
func eb_physics_process(delta: float):
	pass
