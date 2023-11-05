extends Control

#
# nodes
#

@onready var current_heat_label_node: Label = %Current
@onready var thresh_heat_label_node: Label = %Thresh

#
# signal connections
#

func _on_heat_heat_changed(value: float):
	current_heat_label_node.text = '%.2f' % value

func _on_heat_thresh_changed(value: float):
	thresh_heat_label_node.text = '%.2f' % value
