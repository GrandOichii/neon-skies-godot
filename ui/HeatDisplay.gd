extends Control

#
# nodes
#

@onready var current_heat_label_node: Label = %Current
@onready var thresh_heat_label_node: Label = %Thresh
@onready var main_node: Control = %Main
@onready var progress_node: Control = %Progress

#
# private vars
#

var _heat: float
var _thresh: float

#
# signal connections
#

func _on_heat_heat_changed(value: float):
	_heat = value
	current_heat_label_node.text = '%.2f' % value
	
	# update progress
	progress_node.position.x = value * main_node.size.x / _thresh - progress_node.size.x
	progress_node.position.x = min(0, progress_node.position.x)

func _on_heat_thresh_changed(value: float):
	_thresh = value
	thresh_heat_label_node.text = '%.2f' % value
