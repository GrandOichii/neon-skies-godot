extends StaticAbility

#
# exports
#

@export var increase: int

#
# methods
#

func activate():
	super.activate()
	var health = parent.get_node('Health') as ClampedValue
	health.max_value += increase
	
func deactivate():
	super.deactivate()
	var health = parent.get_node('Health') as ClampedValue
	health.max_value -= increase
