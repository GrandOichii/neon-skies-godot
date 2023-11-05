extends StaticAbility

#
# exports
#

@export var increase: int

func activate():
	super.activate()
	var heat = parent.get_node('Heat') as HeatController
	heat.heat_reduction += increase
	
func deactivate():
	super.deactivate()
	var heat = parent.get_node('Heat') as HeatController
	heat.heat_reduction -= increase
