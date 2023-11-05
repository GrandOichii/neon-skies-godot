extends ActivatedAbility
# TODO add some resource consumption

#
# exports
#

var heal_after: float
var heal_amount: int = 1

#
# nodes
#

@onready var heal_after_timer_node: Timer = %HealAfterTimer

#
# methods
#

func _ready():
	if heal_after > 0:
		heal_after_timer_node.wait_time = heal_after

func start_ability():
	super.start_ability()
	if heal_after == 0:
		end_ability()
		return
	heal_after_timer_node.start()
	
func end_ability():
	super.end_ability()
	(parent.get_node('Health') as Health).health += 1

#
# signal connections
#

func _on_heal_after_timer_timeout():
	end_ability()
