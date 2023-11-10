extends StaticAbility
class_name ICMaxIncrease

#
# exports
#

@export var increase: int

#
# methods
#

func activate():
	super.activate()
	var ic = parent.get_node('ImplantConsumable') as ClampedValue
	print(ic.max_value)
	ic.max_value += increase
	
func deactivate():
	super.deactivate()
	var ic = parent.get_node('ImplantConsumable') as ClampedValue
	ic.max_value -= increase

