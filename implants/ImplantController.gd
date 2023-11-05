extends Node
class_name ImplantController

#
# signals
#

signal implant_installed(slot: Implant.Slot, implant: Implant)
signal implant_uninstalled(slot: Implant.Slot, implant: Implant)

#
# exports
#

@export var implant_slots: Array[ImplantSlot]
@export var parent: Node

#
# nodes
#

@onready var abilities_node: Node = %Abilities

#
# private vars
#

var _slots: Dictionary = {}
var _implant_abilities: Dictionary = {}

#
# methods
#

func _ready():
	# initial install
	for slot in implant_slots:
		if slot.implant == null: continue
		install(slot.slot, slot.implant)
		
func install(slot: Implant.Slot, implant: Implant):
	_slots[slot] = implant
	
	# add abilities
	var ability_arr = []
	for ability_template in implant.ablities:
		var ability = ability_template.instantiate() as Ability
		# TODO doesn't work
		ability.parent = parent
		ability.activate()
		ability_arr.push_front(ability)
		abilities_node.add_child(ability)
	_implant_abilities[implant] = ability_arr
	
	implant_installed.emit(slot, implant)
	
func uninstall(slot: Implant.Slot):
	var implant = _slots[slot]
	if implant == null:
		push_warning('Tried to uninstall from empty slot ' + str(slot))
		return
	_slots[slot] = null
	
	# remove abilities
	for ability in _implant_abilities[implant]:
		ability.deactivate(parent)
		ability.queue_free()
	_implant_abilities.erase(implant)
	
	
	implant_uninstalled.emit(slot, implant)

func get_activated_abilities() -> Array[ActivatedAbility]:
	var result: Array[ActivatedAbility] = []
	
	for a_list in _implant_abilities.values():
		for ability in a_list:
			if not ability is ActivatedAbility:
				continue
			result.push_back(ability)
	
	return result
