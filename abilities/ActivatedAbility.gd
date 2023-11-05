extends Ability
class_name ActivatedAbility

#
# signals
#

signal started
signal ended

#
# exports
#

@export var player_input: String

#
# private vars
#

var _active: bool = false

#
# methods
#

func do():
	if _active: return
	
	_active = true
	start_ability()
	
func start_ability():
	started.emit()
	
func end_ability():
	ended.emit()
	_active = false
