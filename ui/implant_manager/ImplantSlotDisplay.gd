extends Control
class_name ImplantSlotDisplay

#
# exports
#

@export var slot: Implant.Slot

#
# nodes
#

@onready var slot_name_label_node: Label = %SlotName
@onready var display_holder: Control = %DisplayHolder

#
# methods
#

func _ready():
	slot_name_label_node.text = Implant.Slot.keys()[slot]

func has_installed_implant() -> bool:
	return display_holder.get_child_count() == 1
