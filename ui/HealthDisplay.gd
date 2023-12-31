extends HBoxContainer

#
# nodse
#

@onready var health_display: Label = %Health

#
# vars
#

var _value: int
var _max_value: int

#
# methods
#

func _apply_changes():
	health_display.text = '' + str(_value) + ' / ' + str(_max_value)

#
# signal connections
#

func _on_health_changed(to: int):
	_value = to
	_apply_changes()

func _on_health_max_changed(to):
	_max_value = to
	_apply_changes()
	
