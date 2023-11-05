extends Node

#
# signals
#

signal toggled(value: bool)

#
# exports
#

@export var parent: Control
@export var input: String

#
# private vars
#

var _visible: bool = false

#
# methods
#

func _ready():
	parent.hide()
	parent.position.y = -parent.size.y
	
	# TODO remove
	_toggle()
	
func _input(event):
	if event.is_action_pressed('dev-im-toggle'):
		_toggle()
		
func _toggle():
	var target_y = 0
	if _visible:
		target_y = -parent.size.y
	else:
		parent.show()
		
	var v = _visible
	create_tween().tween_property(parent, 'position', Vector2(parent.position.x, target_y), .2).finished.connect(func _finish(): if v: parent.hide())
	_visible = not _visible
	
	toggled.emit(_visible)
