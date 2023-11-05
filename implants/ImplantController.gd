extends Node
class_name ImplantsController

#
# signals
#

signal slots_initialized
signal implant_installed(slot: Implant.Slot, implant: Implant)
signal implant_uninstalled(slot: Implant.Slot, implant: Implant)
signal ability_added(ability: Ability)
signal ability_removed(ability: Ability)

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
# vars
#
var slots: Dictionary = {}

#
# private vars
#

var _implant_abilities: Dictionary = {}

#
# methods
#

func _ready():
	# initial install
	for slot in implant_slots:
		slots[slot.slot] = null
		if slot.implant == null: continue
		install(slot.slot, slot.implant)
	slots_initialized.emit()
		
func install(slot: Implant.Slot, implant: Implant):
	slots[slot] = implant
	
	# add abilities
	var ability_arr = []
	for ability_template in implant.ablities:
		var ability = ability_template.instantiate() as Ability
		ability.parent = parent
		ability.activate()
		ability_arr.push_front(ability)
		abilities_node.add_child(ability)
		ability_added.emit(ability)

	_implant_abilities[implant] = ability_arr
	
	implant_installed.emit(slot, implant)
	
func uninstall(slot: Implant.Slot):
	var implant = slots[slot]
	if implant == null:
		push_warning('Tried to uninstall from empty slot ' + str(slot))
		return
	slots[slot] = null
	
	# remove abilities
	for ability in _implant_abilities[implant]:
		ability.deactivate()
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
