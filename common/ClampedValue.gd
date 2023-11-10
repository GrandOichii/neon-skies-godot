extends Node
class_name ClampedValue

#
# signals
#

signal changed(to: int)
signal max_changed(to: int)
signal min_changed(to: int)

#
# exports
#

@export var initial_min: int
@export var initial_value: int
@export var initial_max: int

#
# vars
#

var min_value : int :
	get:
		return min_value
	set(v):
		min_value = v
		min_changed.emit(max_value)
		value = value

var value: int :
	get:
		return value
	set(v):
		var prev = value
		value = clamp(v, min_value, max_value)
		if prev == v:
			return
		changed.emit(value)
		
var max_value: int :
	get:
		return max_value
	set(v):
		max_value = v
		max_changed.emit(max_value)
		value = value

#
# methods
#

func _ready():
	min_value = initial_min
	max_value = initial_max
	value = initial_value
