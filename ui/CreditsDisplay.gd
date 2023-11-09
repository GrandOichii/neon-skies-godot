extends Label

#
# packed scenes
#

@export var credits_mod_label_ps: PackedScene

#
# nodes
#

@onready var credits_mod_container_node: VBoxContainer = %CreditsModContainer

#
# private vars
#

var _amount: int

#
# signal connections
#

func _on_player_credits_changed(value: int):
	var prev = _amount
	var diff = value - prev
	_amount = value
	text = str(value)
	
	var child = credits_mod_label_ps.instantiate() as CreditsModLabel
	credits_mod_container_node.add_child(child)
	child.begin(diff)
