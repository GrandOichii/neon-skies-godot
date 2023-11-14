extends Control
class_name ImplantDisplay

#
# signals
#

signal pressed
signal hover_start
signal hover_end

#
# nodes
#

@onready var image_node: TextureRect = %Image
@onready var name_label_node: Label = %Name

#
# vars
#

var installed: bool = false

var implant: Implant :
	get:
		return implant
	set(value):
		implant = value
		# TODO set image
		name_label_node.text = implant.name

#
# signal connections
#

func _on_texture_button_pressed():
	pressed.emit()
