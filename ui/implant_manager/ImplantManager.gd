extends Control

#
# exports
#

@export var stored_implants: Array[Implant]

#
# nodes
#

#
# private vars
#

var _visible: bool = false

#
# methods
#

func _ready():
	hide()
	position.y = -size.y
	
func _input(event):
	if event.is_action_pressed('dev-im-toggle'):
		_toggle()
		
func _toggle():
	var target_y = 0
	if _visible:
		target_y = -size.y
	else:
		show()
		
	var v = _visible
	create_tween().tween_property(self, 'position', Vector2(position.x, target_y), .2).finished.connect(func _finish(): if v: hide())
	_visible = not _visible
