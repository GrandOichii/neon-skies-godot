extends StaticAbility

#
# exports
#

@export var increase: int

func activate():
	super.activate()
	var health = parent.get_node('Health') as Health
	health.max_health += increase
	
func deactivate():
	super.deactivate()
	var health = parent.get_node('Health') as Health
	health.max_health -= increase
